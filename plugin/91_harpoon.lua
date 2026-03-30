vim.pack.add({
    "https://github.com/cbochs/grapple.nvim",
})

require("grapple").setup({
    scope = "git",
    icons = true,
    status = false,
})

vim.keymap.set("n", "<leader>m", function() require("grapple").toggle() end, { desc = "[M]ark for grapple" })
vim.keymap.set("n", "<leader>h", function() require("grapple").toggle_tags() end, { desc = "[H]arpoon (grapple)" })

vim.keymap.set("n", "H", function() require("grapple").cycle_tags("prev") end)
vim.keymap.set("n", "L", function() require("grapple").cycle_tags("next") end)
