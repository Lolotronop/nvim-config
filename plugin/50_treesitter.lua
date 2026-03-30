vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/windwp/nvim-ts-autotag",
})

require("nvim-treesitter").setup({
	ensure_installed = {
		"bash",
		"c",
		"diff",
		"html",
		"javascript",
		"jsdoc",
		"json",
		"lua",
		"luadoc",
		"luap",
		"markdown",
		"markdown_inline",
		"printf",
		"python",
		"query",
		"regex",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"xml",
		"yaml",

		"svelte",
		"css",
	},
})

require('nvim-ts-autotag').setup()


vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
	callback = function(ev)
		local buf = ev.buf
		local filetype = ev.match

		local language = vim.treesitter.language.get_lang(filetype) or filetype
		if not vim.treesitter.language.add(language) then
			return
		end

		vim.treesitter.start(buf, language)
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == 'nvim-treesitter' and kind == 'update' then
			if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
			vim.cmd('TSUpdate')
		end
	end
})

-- got this from here https://pawelgrzybek.com/nvim-incremental-selection/#update-20260309
-- incremental selection
vim.keymap.set({ 'x', 'o', 'n' }, '<C-k>', function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require 'vim.treesitter._select'.select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end, { desc = 'Select parent treesitter node or outer incremental lsp selections' })

vim.keymap.set({ 'x', 'o' }, '<C-j>', function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require 'vim.treesitter._select'.select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(-vim.v.count1)
	end
end, { desc = 'Select child treesitter node or inner incremental lsp selections' })
