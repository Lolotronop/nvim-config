return {
    -- THEME
    {
        'luisiacc/gruvbox-baby',
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_baby_telescope_theme = 1
            vim.g.gruvbox_baby_keyword_style = "bold"
            vim.g.gruvbox_baby_comment_style = "altfont"
            vim.g.gruvbox_baby_background_color = "dark"
            vim.g.gruvbox_baby_transparent_mode = 1
            vim.cmd [[colorscheme gruvbox-baby]]

            vim.cmd('highlight! clear SpellBad')
            vim.cmd('highlight! clear SpellCap')
            vim.cmd('highlight! clear SpellLocal')
            vim.cmd('highlight! clear SpellRare')
            vim.cmd('highlight! SpellBad gui=underline')
            vim.cmd('highlight! SpellCap gui=underline')
            vim.cmd('highlight! SpellLocal gui=underline')
            vim.cmd('highlight! SpellRare gui=underline')
        end
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function ()
            require("ibl").setup({
                exclude = {
                    filetypes = {
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
                        "man",
                        "lspinfo",
                        "TelescopePrompt",
                        "TelescopeResult"
                    }
                },
                indent = {
                    -- char = {'┊'},
                    char = '▏',
                }
            })
        end
    },

    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {},
    },

    {
        "ThePrimeagen/harpoon",
        opts = {
            -- tabline = false
        },
        lazy = true,
        keys = {
            -- {"<leader>h", ":lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Open harpoon menu"},
            -- {"L", ":lua require('harpoon.ui').nav_next()<cr>", desc = "Next harpoon marker"},
            -- {"H", ":lua require('harpoon.ui').nav_prev()<cr>", desc = "Prev harpoon marker"},
            { "<leader>h", function() require('harpoon.ui').toggle_quick_menu() end, desc = "Open harpoon menu" },
            { "L",         function() require('harpoon.ui').nav_next() end,          desc = "Next harpoon marker" },
            { "H",         function() require('harpoon.ui').nav_prev() end,          desc = "Prev harpoon marker" },
            { "<leader>m", function() require("harpoon.mark").add_file() end,        desc = "Add marker here" },

        },
        config = function(_, opts)
            vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
            vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
            vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
            vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
            vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')
            require("harpoon").setup(opts)
        end
    },

    {
        "rcarriga/nvim-notify",
        lazy = true,
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
            require("telescope").load_extension("notify")
        end,
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        event = 'VeryLazy',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { "gd",         "<cmd>Telescope lsp_definitions<cr>",      desc = "Goto Definition" },
            { "gr",         "<cmd>Telescope lsp_references<cr>",       desc = "References" },
            { "gI",         "<cmd>Telescope lsp_implementations<cr>",  desc = "Goto Implementation" },
            { "gy",         "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
            { "<leader>cs", "<cmd>Telescope spell_suggest<cr>",        desc = "Spell suggest for word under cursor" },
            { "<leader>ce", "<cmd>Telescope diagnostics<cr>",          desc = "Show workspace diagnostics" },
            { "<leader>ff", "<cmd>Telescope find_files<cr>",           desc = "Find file" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>",             desc = "Open Recent File" },
            { "<leader>fs", "<cmd>Telescope live_grep<cr>",            desc = "Open Recent File" },
            { "<leader>fn", "<cmd>enew<cr>",                           desc = "New file" },
        },
        opts = {},
        config = function()
            local actions = require("telescope.actions")
            local opts = {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                },
            }
            require("telescope").setup(opts)
        end
    },

    { 'MunifTanjim/nui.nvim', lazy = true },

    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        cmd = { "TroubleToggle", "Trouble" },
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        opts = { use_diagnostic_signs = true, icons = true },
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false,       -- add a border to hover docs and signature help
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    },

    {
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy",
        opts = {
            theme = "gruvbox",
            sections = {
                lualine_b = { "branch", },
                lualine_c = { "filename", "diagnostics" },
            },
            extensions = { "trouble" },
        },
    },

    {
        "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
        config = function ()
            local rainbow_delimiters = require 'rainbow-delimiters'

            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rainbow_delimiters.strategy['global'],
                    vim = rainbow_delimiters.strategy['local'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
                highlight = {
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterCyan',
                    'RainbowDelimiterRed',
                },
            }
        end
    }
}
