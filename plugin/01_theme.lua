vim.pack.add({
	"https://github.com/luisiacc/gruvbox-baby",
})
vim.g.gruvbox_baby_keyword_style = "bold"
vim.g.gruvbox_baby_comment_style = "altfont"
vim.g.gruvbox_baby_background_color = "dark"
vim.g.gruvbox_baby_transparent_mode = 1
vim.cmd([[colorscheme gruvbox-baby]])

vim.cmd("highlight! BlinkCmpMenu guibg=#1d2021 ctermbg=NONE")
vim.cmd("highlight! BlinkCmpMenuSelection guibg=#3c3836 ctermbg=NONE")

vim.cmd("highlight! SnacksIndentScope guifg=#665c54 ctermbg=NONE")
vim.cmd("highlight! SnacksIndent guifg=#282828 ctermbg=NONE")

vim.cmd("highlight! MiniIconsAzure guifg=#2f74c0 ctermbg=NONE")

vim.cmd("highlight! clear SpellBad")
vim.cmd("highlight! clear SpellCap")
vim.cmd("highlight! clear SpellLocal")
vim.cmd("highlight! clear SpellRare")
vim.cmd("highlight! SpellBad gui=underline")
vim.cmd("highlight! SpellCap gui=underline")
vim.cmd("highlight! SpellLocal gui=underline")
vim.cmd("highlight! SpellRare gui=underline")

require("gruvbox-baby")
