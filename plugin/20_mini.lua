vim.pack.add({
    "https://github.com/nvim-mini/mini.nvim"
})

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
require('mini.basics').setup()

local spec_treesitter = require("mini.ai").gen_spec.treesitter
require("mini.ai").setup({
	n_lines = 500,
	custom_textobjects = {
		f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
		o = spec_treesitter({
			a = { "@conditional.outer", "@loop.outer" },
			i = { "@conditional.inner", "@loop.inner" },
		}),
	},
})

require("mini.icons").setup()
