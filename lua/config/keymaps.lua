local function set_map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.desc = opts.desc or rhs
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
        opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
end

local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    -- do not create the keymap if a lazy keys handler exists
    if not keys then
        set_map(mode, lhs, rhs, opts)
        return
    end
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
        set_map(mode, lhs, rhs, opts)
    end
end

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

map("t", "<C-h>", "<c-\\><c-n><c-w>hh", { desc = "Go to left window" })
map("t", "<C-j>", "<c-\\><c-n><c-w>j", { desc = "Go to lower window" })
map("t", "<C-k>", "<c-\\><c-n><c-w>k", { desc = "Go to upper window" })
map("t", "<C-l>", "<c-\\><c-n><c-w>l", { desc = "Go to right window" })

map("i", "jk", "<Esc>", { desc = "Faster exit" })
map("i", "kj", "<Esc>", { desc = "Faster exit" })
map("i", "Jk", "<Esc>", { desc = "Faster exit" })
map("i", "jK", "<Esc>", { desc = "Faster exit" })
map("i", "JK", "<Esc>", { desc = "Faster exit" })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "L", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "H", "<cmd>bp<cr>", { desc = "Previous buffer" })

map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

map("n", "<leader>p", ":LspZeroFormat<cr><cr>", { desc = "format the thing" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })

map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })

map("n", "<leader>e", function()
    local ok, res = pcall(vim.cmd, 'Rex')
    if not ok then
        vim.cmd [[Ex]]
    end
end, { desc = "Open file explorer" })

-- Could not it to get to work with lua, keymaps for file explorer
vim.cmd [[au FileType netrw nmap <buffer> h -]]
vim.cmd [[au FileType netrw nmap <buffer> l <cr>]]
vim.cmd [[au FileType netrw nmap <buffer> f %]]
