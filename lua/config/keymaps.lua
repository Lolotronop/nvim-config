local wk = require("which-key")
local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    -- do not create the keymap if a lazy keys handler exists
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
        opts = opts or {}
        opts.desc = opts.desc or rhs
        opts.silent = opts.silent ~= false
        if opts.remap and not vim.g.vscode then
            opts.remap = nil
        end
        vim.keymap.set(mode, lhs, rhs, opts)
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
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "L", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "H", "<cmd>bp<cr>", { desc = "Previous buffer" })

map("i", "<c-k>", vim.lsp.buf.signature_help,  { desc = "Signature Help" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

map("n", "<leader>ca", vim.lsp.buf.code_action, {desc = "code action"})
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info"  })

map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Goto Definition" })
map("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References"  })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { desc = "Goto Implementation" })
map("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Goto T[y]pe Definition" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {desc = "Find file"})
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", {desc = "Open Recent File"})
map("n", "<leader>fn", "<cmd>enew<cr>", {desc = "New file"})

map("n", "<leader>t", "<cmd>ToggleTerm size=80 direction=vertical<cr>", { desc = "ToggleTerm vertical split" })
map("t", "<leader>t", "<cmd>ToggleTerm size=80 direction=vertical<cr>", { desc = "ToggleTerm vertical split" })
