vim.keymap.set("i", "jk", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "Jk", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "jK", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "JK", "<Esc>", { desc = "Faster exit" })

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })

vim.keymap.set("n", "P", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("n", "Y", '"+y', { desc = "Copy to clipboard" })

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })

vim.keymap.set("n", "<leader>e", function()
    local ok, res = pcall(vim.cmd, "Rex")
    if not ok then
        vim.cmd([[Ex]])
    end
end, { desc = "Open file explorer" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keyvim.keymap.sets
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Could not it to get to work with lua, keymaps for file explorer
vim.cmd([[au FileType netrw nmap <buffer> h -]])
vim.cmd([[au FileType netrw nmap <buffer> l <cr>]])
vim.cmd([[au FileType netrw nmap <buffer> f %]])
