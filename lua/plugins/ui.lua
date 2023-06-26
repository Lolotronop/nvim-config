return {
    -- THEME
    {
        'luisiacc/gruvbox-baby',
        lazy = false,
        config = function()
            vim.g.gruvbox_baby_telescope_theme = 1
            vim.g.gruvbox_baby_background_color = "dark"
            -- vim.g.gruvbox_baby_transparent_mode = 1
            vim.cmd[[colorscheme gruvbox-baby]]
        end
    },

    {
        "akinsho/toggleterm.nvim",
        cmd = "ToggleTerm",
        opts = function()
            if vim.loop.os_uname().sysname == "Windows_NT" then
                require("toggleterm").setup({
                    shell = "nu",
                })
            else
                require("toggleterm").setup({
                    shell = 'fish'
                })
            end
        end,
    },

    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                -- stylua: ignore
                close_command = function(n) require("mini.bufremove").delete(n, false) end,
                -- stylua: ignore
                right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
                diagnostics = "nvim_lsp",
                always_show_bufferline = true,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            char = "┊",
            filetype_exclude = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "Trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
            },
            show_trailing_blankline_indent = true,
            show_current_context = true,
        },
    },

    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all Notifications",
            },
        },
        opts = {
            timeout = 6000,
            background_colour = "#000000",
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
        init = function()
            -- when noice is not enabled, install notify on VeryLazy
            -- local Util = require("lazyvim.util")
            -- if not Util.has("noice.nvim") then
            --     Util.on_very_lazy(function()
            --         vim.notify = require("notify")
            --     end)
            -- end

            vim.notify = require("notify")
        end,
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end
    },

    {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        event = 'VeryLazy',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {'MunifTanjim/nui.nvim', lazy = true},
    {'kyazdani42/nvim-web-devicons', lazy = true},

    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true, icons = true },
    },
}
