return {
    {
        "kdheepak/lazygit.nvim",
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        lazy = true,
    },

    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },

    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
                end,
            },

            mappings = {
                comment = "<leader>/",
                comment_line = "<leader>/",
                textobject = "<leader>/",
            }
        },
    },
}
