vim.pack.add({
	"https://github.com/luisiacc/gruvbox-baby",
})

vim.g.gruvbox_baby_keyword_style = "bold"
vim.g.gruvbox_baby_comment_style = "altfont"
vim.g.gruvbox_baby_background_color = "dark"
vim.g.gruvbox_baby_transparent_mode = 1

require("gruvbox-baby")

vim.cmd([[colorscheme gruvbox-baby]])

local hl = vim.api.nvim_set_hl

hl(0, "BlinkCmpMenu", { bg = "#1d2021" })
hl(0, "BlinkCmpMenuSelection", { bg = "#3c3836" })

hl(0, "SnacksIndentScope", { fg = "#665c54" })
hl(0, "SnacksIndent", { fg = "#282828" })

hl(0, "MiniIconsAzure", { fg = "#2f74c0" })

-- clear then set underline for spelling highlights
hl(0, "SpellBad", {}) -- clears previous attrs
hl(0, "SpellCap", {})
hl(0, "SpellLocal", {})
hl(0, "SpellRare", {})

hl(0, "SpellBad", { underline = true })
hl(0, "SpellCap", { underline = true })
hl(0, "SpellLocal", { underline = true })
hl(0, "SpellRare", { underline = true })

-- muted
hl(0, "MiniDiffSignAdd", { fg = "#98971a" })
hl(0, "MiniDiffSignChange", { fg = "#d79921" })
hl(0, "MiniDiffSignDelete", { fg = "#cc241d" })

hl(0, "MiniStatuslineFilename", { fg = "#ebdbb2" })
hl(0, "MiniStatuslineFileinfo", { fg = "#bdae93" })
hl(0, "MiniStatuslineDevinfo", { fg = "#bdae93" })
hl(0, "MiniStatuslineModeNormal", { bg = "#656411" })
