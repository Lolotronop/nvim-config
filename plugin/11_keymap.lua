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

vim.keymap.set("n", "<leader>rr", function()
    local buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" then
        print("No file to re-edit")
        return
    end
    vim.cmd("restart edit " .. vim.fn.fnameescape(name))
end, { noremap = true, silent = true, desc = "Restart neovim" })

local loaded_undotree = false
vim.keymap.set("n", "<leader>u", function()
    if not loaded_undotree then
        vim.cmd("packadd nvim.undotree")
        loaded_undotree = true
    end
    require("undotree").open({
        command = math.floor(vim.api.nvim_win_get_width(0) / 3) .. "vnew",
    })
end, { desc = "[U]ndotree toggle" })


vim.keymap.set("n", "<leader>q", function()
    local current_win = vim.api.nvim_get_current_win()

    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            vim.cmd("cclose")
            return
        end
    end

    vim.cmd("copen")

    if vim.api.nvim_win_is_valid(current_win) then
        vim.api.nvim_set_current_win(current_win)
    end
end, {
    desc = "Toggle quickfix without focusing it",
})

vim.keymap.set("n", "<leader>Q", function()
    vim.fn.setqflist({}, "r")
    vim.cmd("cclose")
end, {
    desc = "Clear and close quickfix list",
})
