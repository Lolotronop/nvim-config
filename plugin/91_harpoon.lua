vim.pack.add({
    "https://github.com/cbochs/grapple.nvim",
})

local grapple_loaded = false

local function load_grapple()
    if grapple_loaded then
        return
    end
    grapple_loaded = true

    require("grapple").setup({
        scope = "git",
        icons = true,
        status = false,
    })
end

vim.keymap.set("n", "<leader>m", function()
    load_grapple()
    require("grapple").toggle()
end, { desc = "[M]ark for grapple" })
vim.keymap.set("n", "<leader>h", function()
    load_grapple()
    require("grapple").toggle_tags()
end, { desc = "[H]arpoon (grapple)" })

vim.keymap.set("n", "H", function()
    load_grapple()
    require("grapple").cycle_tags("prev")
end)
vim.keymap.set("n", "L", function()
    load_grapple()
    require("grapple").cycle_tags("next")
end)
