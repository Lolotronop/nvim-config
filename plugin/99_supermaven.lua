vim.pack.add({
    "https://github.com/supermaven-inc/supermaven-nvim",
})

local supermaven_loaded = false

local function load_supermaven()
    if supermaven_loaded then
        return
    end
    supermaven_loaded = true

    require("supermaven-nvim").setup({
        disable_keymaps = true,
    })
end

vim.api.nvim_create_autocmd("InsertEnter", {
    group = vim.api.nvim_create_augroup("myconf_load_supermaven", { clear = true }),
    once = true,
    callback = load_supermaven,
})

vim.keymap.set("i", "<c-g>", function()
    load_supermaven()
    require("supermaven-nvim.completion_preview").on_accept_suggestion()
end)
