vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.spell = true
vim.opt.spelllang = "ru_ru,en_us"
vim.opt.list = true
vim.opt.listchars = {
    tab = "  ",
    trail = "·",
    nbsp = "␣",
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"
vim.opt.cmdwinheight = 12
vim.opt.incsearch = true
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.wrap = true

-- fix bun
vim.opt.backupcopy = "yes"

vim.diagnostic.config({
    severity_sort = true,
    virtual_lines = false,
    virtual_text = true,
    underline = true,
})

-- hide cmdline until you type
vim.opt.cmdheight = 0
-- optional: don't show partial commands in the corner
vim.opt.showcmd = false

vim.opt.swapfile = false
vim.opt.shada = { "'10", "<0", "s10", "h" }

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
