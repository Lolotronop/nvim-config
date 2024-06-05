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
            -- require("mini.pairs").setup()
        end,
    },

    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        branch = "v0.6",
        opts = {},
    },

    {
        "windwp/nvim-ts-autotag",
        opts = {},
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
            local set = vim.keymap.set

            set("n", "<leader>m", function()
                harpoon:list():add()
            end)
            set("n", "<leader>h", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end)

            set("n", "H", function()
                harpoon:list():prev()
            end)
            set("n", "L", function()
                harpoon:list():next()
            end)
        end,
    },
}
