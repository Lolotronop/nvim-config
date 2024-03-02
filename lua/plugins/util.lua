return {
    "tpope/vim-sleuth",

    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        dependencies = {
            { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
        },
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring()
                        or vim.bo.commentstring
                end,
                ignore_blank_line = true,
                start_of_line = false,
            },

            mappings = {
                comment = "<leader>/",
                comment_line = "<leader>/",
                comment_visual = "<leader>/",
                textobject = "<leader>/",
            },
        },
    },

    {
        "smjonas/inc-rename.nvim",
        keys = {
            { "<leader>cr", ":IncRename ", desc = "Code Rename" },
        },
        config = function()
            require("inc_rename").setup({ input_buffer_type = "dressing" })
        end,
    },

    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        config = function()
            require("mini.ai").setup({ n_lines = 500 })

            require("mini.surround").setup()
            require("mini.pairs").setup()
        end,
    },

    {
        "cbochs/grapple.nvim",
        event = "BufReadPost",
        opts = {},
        config = function()
            -- Lua
            vim.keymap.set("n", "<leader>m", function()
                require("grapple").toggle({ scope = "cwd" })
            end)
            vim.keymap.set("n", "<leader>h", function()
                require("grapple").toggle_tags({ scope = "cwd" })
            end)
            vim.keymap.set("n", "L", function()
                require("grapple").cycle("forward", { scope = "cwd" })
            end)
            vim.keymap.set("n", "H", function()
                require("grapple").cycle("backward", { scope = "cwd" })
            end)
        end,
    },
}
