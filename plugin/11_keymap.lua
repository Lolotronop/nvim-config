vim.keymap.set("i", "jk", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "Jk", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "jK", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("i", "JK", "<Esc>", { desc = "Faster exit" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })

vim.keymap.set("v", "<leader>r", 'y:%s/\\V<C-r>"//g<Left><Left>', {
  noremap = true,
  silent = false,
  desc = "Replace visual selection in whole file",
})

vim.keymap.set("n", "<M-l>", "<cmd>cnext<CR>", { desc = "Next [L]ist" })
vim.keymap.set("n", "<M-h>", "<cmd>cprevious<CR>", { desc = "Previous [L]ist" })

vim.keymap.set('n', '<leader>r', function()
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  if name == '' then
    print('No file to re-edit')
    return
  end
  vim.cmd('restart edit ' .. vim.fn.fnameescape(name))
end, { noremap = true, silent = true, desc = "Restart neovim" })
