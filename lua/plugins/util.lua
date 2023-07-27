return {
    {
        "smjonas/inc-rename.nvim",
        lazy = true,
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
        dependencies = {
            { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
        },
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

    {
        "echasnovski/mini.bufremove",
        lazy = true,
        keys = {
            { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
        },
    },
    { 'echasnovski/mini.ai', event = "VeryLazy", version = false, opts = {}},
    { 'echasnovski/mini.pairs', event = "VeryLazy", version = false, opts = {}},
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {"nvim-treesitter"},
        event = "VeryLazy",
    },

    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter"
        },
        keys = {
            { "<leader>cp", function() require("refactoring").debug.print_var({}) end, desc = "Debug-print variable under crursor" },
            { "<leader>cp", function() require("refactoring").debug.print_var({}) end, desc = "Debug-print variable under crursor", mode = "v"},
        },
        opts = {},
    },
}
