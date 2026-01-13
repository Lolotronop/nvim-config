vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.diagnostic.config({
    severity_sort = true,
    virtual_lines = { current_line = true },
    virtual_text = { current_line = false },
    underline = true,
})

local og_virt_text
local og_virt_line
vim.api.nvim_create_autocmd({ "CursorMoved", "DiagnosticChanged" }, {
    group = vim.api.nvim_create_augroup("diagnostic_only_virtlines", {}),
    callback = function()
        if og_virt_line == nil then
            og_virt_line = vim.diagnostic.config().virtual_lines
        end

        -- ignore if virtual_lines.current_line is disabled
        if not (og_virt_line and og_virt_line.current_line) then
            if og_virt_text then
                vim.diagnostic.config({ virtual_text = og_virt_text })
                og_virt_text = nil
            end
            return
        end

        if og_virt_text == nil then
            og_virt_text = vim.diagnostic.config().virtual_text
        end

        local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

        if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
            vim.diagnostic.config({ virtual_text = og_virt_text })
        else
            vim.diagnostic.config({ virtual_text = false })
        end
    end,
})

vim.opt.termguicolors = true

vim.opt.expandtab = true

vim.opt.pumblend = 0 -- Popup blend
vim.opt.pumheight = 15 -- Maximum number of entries in a popup
vim.opt.scrolloff = 4
-- vim.opt.wildmode = "longest:full,full"
vim.opt.winminwidth = 5
vim.opt.splitkeep = "screen"
vim.opt.spelllang = "ru_ru,en_us"
vim.opt.spell = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false

vim.opt.breakindent = true
vim.opt.wrap = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {
    tab = "  ",
    trail = "·",
    nbsp = "␣",
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"
vim.opt.cmdwinheight = 15
vim.opt.incsearch = true

vim.opt.cursorline = true

vim.opt.hlsearch = true

-- fix bun
vim.opt.backupcopy = "yes"

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("myconf_jumplast", { clear = true }),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- :OpenAllTs — add and load all .ts and .svelte under 'src' into buffers
local function chunk(tbl, n)
    local chunks = {}
    for i = 1, #tbl, n do
        table.insert(chunks, vim.list_slice(tbl, i, math.min(i + n - 1, #tbl)))
    end
    return chunks
end

local function open_all_ts_and_svelte()
    -- collect files
    local ts = vim.fn.globpath("src", "**/*.ts", 0, 1)
    local svelte = vim.fn.globpath("src", "**/*.svelte", 0, 1)
    local files = {}
    for _, f in ipairs(ts) do
        files[#files + 1] = f
    end
    for _, f in ipairs(svelte) do
        files[#files + 1] = f
    end

    -- exclude shadcn UI components under src/lib/components/ui
    local function is_excluded(path)
        return path:match("^src/lib/components/ui/") ~= nil
    end
    local filtered = {}
    for _, f in ipairs(files) do
        if not is_excluded(f) then
            filtered[#filtered + 1] = f
        end
    end
    files = filtered

    if #files == 0 then
        print("No .ts or .svelte files found under src")
        return
    end

    -- avoid duplicate entries
    table.sort(files)
    local uniq = {}
    for i = 1, #files do
        if files[i] ~= files[i - 1] then
            uniq[#uniq + 1] = files[i]
        end
    end
    files = uniq

    -- batch to avoid command-length limits
    local batch_size = 40

    for _, batch in ipairs(chunk(files, batch_size)) do
        -- add to arglist safely
        local escaped = vim.tbl_map(vim.fn.fnameescape, batch)
        vim.cmd("silent argadd " .. table.concat(escaped, " "))

        -- load each file into a hidden buffer so LSP will index it
        for _, filepath in ipairs(batch) do
            -- skip if already loaded
            local bufnr = vim.fn.bufnr(filepath, true)
            if bufnr == -1 then
                -- create buffer and load file into it (no window shown)
                bufnr = vim.api.nvim_create_buf(false, true) -- listed=false, scratch=true
                vim.api.nvim_buf_set_name(bufnr, filepath)
                -- try to read file into buffer
                local ok, _ = pcall(vim.api.nvim_buf_attach, bufnr, false, {})
                vim.cmd(string.format("silent keepalt buffer %s | silent edit %s", bufnr, vim.fn.fnameescape(filepath)))
                -- hide it again
                vim.cmd("bprevious") -- go back to previous buffer/window
            else
                -- ensure buffer is loaded
                if not vim.api.nvim_buf_is_loaded(bufnr) then
                    vim.fn.bufload(bufnr)
                end
            end
            -- give LSP a moment: notify bufread for servers listening
            vim.api.nvim_command("doautocmd User OpenAllTsBufferLoaded")
        end
    end

    -- open first file in current window for convenience
    vim.cmd("silent edit " .. vim.fn.fnameescape(files[1]))
    print(#files .. " files loaded into buffers and added to arglist")
end

vim.api.nvim_create_user_command("opents", open_all_ts_and_svelte, {})
