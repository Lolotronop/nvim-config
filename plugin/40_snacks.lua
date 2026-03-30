vim.pack.add({
	"https://github.com/folke/snacks.nvim",
})

---@type snacks.Config
local opts = {
	bigfile = { enabled = true },
	indent = { enabled = true, char = "▏", animate = { enabled = false } },
	input = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	picker = {
		enabled = true,
		layout = {
			layout = { -- the layout itself
				width = 0.9, -- 0 is max
				height = 0.9,
			},
		},
	},
}

require("snacks").setup(opts)

vim.keymap.set("n", "<leader>nh", function()
	require("snacks").notifier.show_history()
end, { desc = "Nogification history" })

vim.keymap.set("v", "<leader>s", function()
	vim.cmd('normal! "zy')
	local selection = vim.fn.getreg("z")
	selection = selection:gsub("\n+$", ""):gsub("^%s+", ""):gsub("%s+$", "")
	Snacks.picker.grep()
	vim.schedule(function()
		vim.api.nvim_feedkeys(selection, "n", false)
	end)
end, { desc = "Search for selected text with grep" })

vim.keymap.set("n", "<leader>sh", Snacks.picker.help, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", Snacks.picker.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", Snacks.picker.files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sw", Snacks.picker.grep_word, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", Snacks.picker.grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", Snacks.picker.diagnostics_buffer, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sD", Snacks.picker.diagnostics, { desc = "[S]earch [D]iagnostics all" })
vim.keymap.set("n", "<leader>sr", Snacks.picker.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>sr", Snacks.picker.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "grr", Snacks.picker.lsp_references)
vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions)
vim.keymap.set("n", "cs", Snacks.picker.spelling)
