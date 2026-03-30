vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
})

require("oil").setup({
	keymaps = {
		["h"] = "actions.parent",
		["l"] = "actions.select",
	},
	default_file_explorer = true,
})

vim.keymap.set(
	"n",
	"<leader>e",
	"<CMD>Oil<CR>",
	{ desc = "Open parent directory" }
)
