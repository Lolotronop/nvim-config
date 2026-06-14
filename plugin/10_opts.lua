vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.o.scrolloff = 4

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

local cwd_file = vim.fn.getcwd() .. "/nvim.lua"
if vim.fn.filereadable(cwd_file) == 1 then
    vim.cmd("luafile " .. vim.fn.fnameescape(cwd_file))
end

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

require("vim._core.ui2").enable({
    enable = true, -- Whether to enable or disable the UI.
    msg = {        -- Options related to the message module.
        ---@type 'cmd'|'msg' Default message target, either in the
        ---cmdline or in a separate ephemeral message window.
        ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
        ---or table mapping |ui-messages| kinds and triggers to a target.
        targets = "cmd",
        cmd = {             -- Options related to messages in the cmdline window.
            height = 0.5,   -- Maximum height while expanded for messages beyond 'cmdheight'.
        },
        dialog = {          -- Options related to dialog window.
            height = 0.5,   -- Maximum height.
        },
        msg = {             -- Options related to msg window.
            height = 0.5,   -- Maximum height.
            timeout = 4000, -- Time a message is visible in the message window.
        },
        pager = {           -- Options related to message window.
            height = 1,     -- Maximum height.
        },
    },
})

if vim.g.neovide then
    vim.o.guifont = "IosevkaTerm Nerd Font:h14"
    vim.g.neovide_padding_top = 22
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0
    vim.g.neovide_scroll_animation_length = 0.1
end
