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
