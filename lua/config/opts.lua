vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.diagnostic.config({update_in_insert = true})

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.termguicolors = true
vim.wo.signcolumn = 'yes'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.pumblend = 0 -- Popup blend
vim.o.pumheight = 15 -- Maximum number of entries in a popup
vim.o.scrolloff = 4
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 200 -- Save swap file and trigger CursorHold
vim.o.wildmode = "longest:full,full"
vim.o.winminwidth = 5
vim.o.wrap = true
vim.o.splitkeep = "screen"
vim.o.spelllang = 'ru_ru,en_us'
vim.o.spell = true
vim.o.cursorline = true

vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.o.listchars = "trail:~,tab:>-,nbsp:␣"
vim.o.list = true
