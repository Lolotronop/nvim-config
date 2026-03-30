vim.keymap.set("i", "jk", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "Jk", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "jK", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "JK", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("v", "<leader>r", 'y:%s/\\V<C-r>"//g<Left><Left>', {
	noremap = true,
	silent = false,
	desc = "Replace visual selection in whole file",
})

vim.keymap.set("n", "<M-l>", "<cmd>cnext<CR>", { desc = "Next [L]ist" })
vim.keymap.set("n", "<M-h>", "<cmd>cprevious<CR>", { desc = "Previous [L]ist" })
