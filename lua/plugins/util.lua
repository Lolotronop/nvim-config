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
        event = "VeryLazy",
        keys = {
            { "<leader>cr", ":IncRename ", desc = "Code Rename" },
        },
        config = function()
            require("inc_rename").setup()
        end,
    },

    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        config = function()
            local spec_treesitter = require("mini.ai").gen_spec.treesitter
            require("mini.ai").setup({
                n_lines = 500,
                custom_textobjects = {
                    f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
                    o = spec_treesitter({
                        a = { "@conditional.outer", "@loop.outer" },
                        i = { "@conditional.inner", "@loop.inner" },
                    }),
                },
            })
            require("mini.icons").setup()
            -- MiniIcons.mock_nvim_web_devicons()

            -- require("mini.surround").setup()
            -- require("mini.pairs").setup()
        end,
    },

    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        version = "*",
        opts = {
            mappings = {
                add = "sa", -- Add surrounding in Normal and Visual modes
                delete = "sd", -- Delete surrounding
                find = "sf", -- Find surrounding (to the right)
                find_left = "sF", -- Find surrounding (to the left)
                highlight = "sh", -- Highlight surrounding
                replace = "sr", -- Replace surrounding
                update_n_lines = "sn", -- Update `n_lines`

                suffix_last = "l", -- Suffix to search with "prev" method
                suffix_next = "n", -- Suffix to search with "next" method
            },
        },
    },

    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        branch = "v0.6",
        opts = {},
    },

    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
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

    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", ":UndotreeToggle<CR>", desc = "Undo Tree" },
        },
        config = function()
            vim.g.undotree_WindowLayout = 3
            vim.g.undotree_SplitWidth = 50
            vim.g.undotree_ShortIndicators = 1
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },

    {
        "stevearc/quicker.nvim",
        ft = "qf",
        ---@module "quicker"
        ---@type quicker.SetupOptions
        opts = {},
    },
}
