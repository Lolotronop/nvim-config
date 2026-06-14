vim.pack.add({
    "https://github.com/folke/snacks.nvim",
})

---@type snacks.Config
local opts = {
    bigfile = { enabled = true },
    indent = { enabled = true, char = "▏", animate = { enabled = false } },
    input = { enabled = true },
    notifier = { enabled = true, margin = { right = math.floor(vim.api.nvim_win_get_width(0)) - 9 } },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    picker = {
        enabled = true,
        layout = {
            layout = {       -- the layout itself
                width = 0.9, -- 0 is max
                height = 0.9,
            },
        },
    },
}

require("snacks").setup(opts)

vim.keymap.set("n", "<leader>nh", function()
    require("snacks").notifier.show_history()
end, { desc = "Nogification history" })

vim.keymap.set("v", "<leader>s", function()
    vim.cmd('normal! "zy')
    local selection = vim.fn.getreg("z")
    selection = selection:gsub("\n+$", ""):gsub("^%s+", ""):gsub("%s+$", "")
    Snacks.picker.grep()
    vim.schedule(function()
        vim.api.nvim_feedkeys(selection, "n", false)
    end)
end, { desc = "Search for selected text with grep" })

vim.keymap.set("n", "<leader>sh", Snacks.picker.help, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", Snacks.picker.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", Snacks.picker.files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sw", Snacks.picker.grep_word, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", Snacks.picker.grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", Snacks.picker.diagnostics_buffer, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sD", Snacks.picker.diagnostics, { desc = "[S]earch [D]iagnostics all" })
vim.keymap.set("n", "<leader>sr", Snacks.picker.resume, { desc = "[S]earch [R]esume" })

vim.keymap.set("n", "<leader>sp", function()
    local dirs = {}

    local function add_dir(path)
        path = vim.fs.normalize(vim.fn.expand(path))
        if vim.fn.isdirectory(path) == 1 then
            table.insert(dirs, {
                text = path,
                file = path,
            })
        end
    end

    if vim.fn.has("win32") == 1 then
        for _, path in ipairs(vim.fn.globpath("D:/code", "*", false, true)) do
            add_dir(path)
        end
        add_dir("~/AppData/Local/nvim")
    else
        for _, path in ipairs(vim.fn.globpath("~/code", "*", false, true)) do
            add_dir(path)
        end
        add_dir("~/.config/nvim")
    end

    Snacks.picker.pick({
        source = "code_dirs",
        title = "Code dirs",
        items = dirs,
        format = "file",
        confirm = function(picker, item)
            picker:close()
            if not item then
                return
            end

            local dir = item.file or item.text
            vim.cmd("cd " .. vim.fn.fnameescape(dir))
            vim.cmd("edit .")
        end,
    })
end, { desc = "[S]earch [P]roject dirs" })

vim.keymap.set("n", "grr", Snacks.picker.lsp_references)
vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions)
vim.keymap.set("n", "cs", Snacks.picker.spelling)

vim.keymap.set("n", "<leader>l", function()
    Snacks.lazygit.open({
        theme = {
            [241] = { fg = "Special" },
            activeBorderColor = { fg = "MiniStatuslineModeNormal", bold = true },
            cherryPickedCommitBgColor = { fg = "Identifier" },
            cherryPickedCommitFgColor = { fg = "Function" },
            defaultFgColor = { fg = "Normal" },
            inactiveBorderColor = { fg = "FloatBorder" },
            optionsTextColor = { fg = "Function" },
            searchingActiveBorderColor = { fg = "MatchParen", bold = true },
            selectedLineBgColor = { bg = "Visual" }, -- set to `default` to have no background colour
            unstagedChangesColor = { fg = "DiagnosticError" },
        },
    })
end, { desc = "[L]azyGit" })

local function get_shell()
    if vim.fn.executable("fish") == 1 then
        return "fish"
    end

    if vim.fn.executable("nu.exe") == 1 then
        return "nu.exe"
    end

    return "fish"
end

local shell = get_shell()

---@type snacks.terminal.Opts
local termopts = {
    interactive = true,
    shell = shell,
    win = {
        position = "right",
        max_width = 70,
    },
}

vim.keymap.set("n", "<leader>th", function()
    local termopts2 = vim.tbl_deep_extend("keep", termopts, { create = false })
    local term = Snacks.terminal.get(shell, termopts2)
    if term == nil then
        return
    end
    term:hide()
end, { desc = "[T]erminal [H]ide" })

vim.keymap.set("n", "<leader>tk", function()
    local termopts2 = vim.tbl_deep_extend("keep", termopts, { create = false })
    local term = Snacks.terminal.get(shell, termopts2)
    if term == nil then
        return
    end
    term:close({ buf = true })
end, { desc = "[T]erminal [K]ill" })

vim.keymap.set("n", "<C-t>", function()
    Snacks.terminal.focus(shell, termopts)
end, { desc = "Create/focus terminal" })

vim.keymap.set("t", "<C-t>", function()
    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, "wincmd h")
end, { desc = "Focus main window" })

vim.keymap.set("n", "<leader>tr", function()
    local term = Snacks.terminal.get(shell, termopts)
    if term == nil then
        return
    end

    term:focus()
    -- TODO: make ctrl-c work with nushell. it neesd a delay?
    local keys = vim.api.nvim_replace_termcodes("<UP><CR>", true, false, true)
    vim.api.nvim_feedkeys(keys, "t", false)
    vim.defer_fn(function()
        ---@diagnostic disable-next-line: param-type-mismatch
        pcall(vim.cmd, "wincmd h")
    end, 0)
end, { desc = "[T]erminal [R]re-run" })

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params
            .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
            return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                        value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "",
                        value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})
