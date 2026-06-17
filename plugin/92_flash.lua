vim.pack.add({
    "https://github.com/folke/flash.nvim",
})

local function map(key, mode, action, desc)
    vim.keymap.set(mode, key, action, { desc = desc })
end

require("flash").setup()

map("m", { "n", "x", "o" }, function() require("flash").jump() end, "Flash")
