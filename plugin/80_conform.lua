vim.pack.add({
    "https://github.com/stevearc/conform.nvim",
})

local opts = {
    notify_on_error = true,
    -- format_after_save = false,
    format_after_save = {
        timeout_ms = 500,
        lsp_fallback = true,
        async = true,
    },
    lsp_fallback = true,
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "biome" },
        typescript = { "biome" },
        svelte = { "biome" },
        css = { "biome" },
        html = { "biome" },
    },
}


local done = false
vim.keymap.set(
    "n",
    "<leader>f",
    function()
        if not done then
            require("conform").setup(opts)
            done = true
        end
        require("conform").format({ async = true, lsp_fallback = true })
    end,
    { desc = "Format buffer" }
)

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("myconf_load_conform", { clear = true }),
    callback = function()
        require("conform").setup(opts)
    end,
})
