vim.pack.add({
    "https://github.com/supermaven-inc/supermaven-nvim",
})

require("supermaven-nvim").setup({
    disable_keymaps = true,
})

local suggestion = require("supermaven-nvim.completion_preview")
vim.keymap.set("i", "<c-g>", function()
    suggestion.on_accept_suggestion()
end)
