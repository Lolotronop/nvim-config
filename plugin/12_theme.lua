vim.pack.add({
    "https://github.com/luisiacc/gruvbox-baby",
})

vim.g.gruvbox_baby_keyword_style = "bold"
vim.g.gruvbox_baby_comment_style = "altfont"

vim.g.gruvbox_baby_background_color = "dark"
vim.g.gruvbox_baby_transparent_mode = 1

if vim.g.neovide then
    -- local colors = require("gruvbox-baby.colors").config()
    -- vim.g.gruvbox_baby_highlights = { Normal = { fg = colors.foreground, bg = "#101010" } }
    vim.g.neovide_normal_opacity = 0.8
    vim.g.neovide_title_background_color = string.format(
        "%x",
        vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg
    )

    vim.o.guifont = "IosevkaTerm Nerd Font:h14"
    vim.g.neovide_padding_top = 22
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0
    vim.g.neovide_scroll_animation_length = 0.08
    vim.g.neovide_cursor_animation_length = 0.08
    -- vim.g.neovide_scroll_animation_far_lines = 1
    -- vim.g.neovide_cursor_trail_size = 1
    -- vim.g.neovide_cursor_short_animation_length = 0.04
end

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
