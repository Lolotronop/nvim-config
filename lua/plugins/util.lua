return {
    {
        "kdheepak/lazygit.nvim",
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = "VeryLazy",
    },

    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true  },

    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup({ input_buffer_type = "dressing", })
        end,
        keys = {
            { "<leader>cr", ":IncRename ", desc = "Code Rename" },
        },
    },

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
