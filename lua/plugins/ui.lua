return {
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },

    { -- Useful plugin to show you pending keybinds.
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup()

            require("which-key").add({
                { "<leader>c", group = "[C]ode" },
                { "<leader>d", group = "[D]ocument" },
                { "<leader>s", group = "[S]earch" },
                { "<leader>w", group = "[W]orkspace" },
            })
        end,
    },

    {
        "luisiacc/gruvbox-baby",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_baby_keyword_style = "bold"
            vim.g.gruvbox_baby_comment_style = "altfont"
            vim.g.gruvbox_baby_background_color = "dark"
            vim.g.gruvbox_baby_transparent_mode = 1
            vim.cmd([[colorscheme gruvbox-baby]])

            vim.cmd("highlight! BlinkCmpMenu guibg=#1d2021 ctermbg=NONE")
            vim.cmd("highlight! BlinkCmpMenuSelection guibg=#3c3836 ctermbg=NONE")

            vim.cmd("highlight! SnacksIndentScope guifg=#665c54 ctermbg=NONE")
            vim.cmd("highlight! SnacksIndent guifg=#282828 ctermbg=NONE")

            vim.cmd("highlight! MiniIconsAzure guifg=#2f74c0 ctermbg=NONE")

            vim.cmd("highlight! clear SpellBad")
            vim.cmd("highlight! clear SpellCap")
            vim.cmd("highlight! clear SpellLocal")
            vim.cmd("highlight! clear SpellRare")
            vim.cmd("highlight! SpellBad gui=underline")
            vim.cmd("highlight! SpellCap gui=underline")
            vim.cmd("highlight! SpellLocal gui=underline")
            vim.cmd("highlight! SpellRare gui=underline")
        end,
    },

    {
        "stevearc/dressing.nvim",
        opts = {},
    },

    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            local custom_gruvbox = require("lualine.themes.gruvbox-material")
            local back = vim.opt.background:get()
            custom_gruvbox.normal.c.bg = back
            custom_gruvbox.normal.b.bg = "#32302f"
            require("lualine").setup({
                options = {
                    theme = custom_gruvbox,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    extensions = { "trouble" },
                },
                sections = {
                    lualine_b = { "branch" },
                    lualine_c = {
                        { "filetype", icon_only = true, icon = { align = "right" } },
                        { "filename", path = 1 },
                    },
                    lualine_x = {},
                    lualine_y = { "require'lsp-status'.status()", "diagnostics" },
                },
            })
        end,
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = true,
            },
            lsp = {
                progress = {
                    enabled = false,
                },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },

    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        opts = {
            keymaps = {
                ["h"] = "actions.parent",
                ["l"] = "actions.select",
            },
            default_file_explorer = true,
        },
        keys = {
            {
                "<leader>e",
                "<CMD>Oil<CR>",
                desc = "Open parent directory",
            },
        },
    },

    { "nvim-tree/nvim-web-devicons", opt = {} },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            ---@type snacks.Config
            local opts = {
                bigfile = { enabled = true },
                indent = { enabled = true, char = "▏", animate = { enabled = false } },
                input = { enabled = true },
                notifier = { enabled = true },
                quickfile = { enabled = true },
                statuscolumn = { enabled = true },
                words = { enabled = true },
                picker = {
                    enabled = true,
                    layout = {
                        layout = { -- the layout itself
                            width = 0.9, -- 0 is max
                            height = 0.9,
                        },
                    },
                },
            }
            require("snacks").setup(opts)
            vim.keymap.set("n", "<leader>nh", function()
                require("snacks").notifier.show_history()
            end, { desc = "Snack" })

            vim.keymap.set("v", "<leader>s", function()
                vim.cmd('normal! "zy')
                local selection = vim.fn.getreg("z")
                selection = selection:gsub("\n+$", ""):gsub("^%s+", ""):gsub("%s+$", "")
                Snacks.picker.grep()
                vim.schedule(function()
                    vim.api.nvim_feedkeys(selection, "n", false)
                end)
            end, { desc = "Search for selected text with grep" })

            vim.keymap.set("n", "<leader>sh", Snacks.picker.help, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sk", Snacks.picker.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sf", Snacks.picker.files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>sw", Snacks.picker.grep_word, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>sg", Snacks.picker.grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sd", Snacks.picker.diagnostics_buffer, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sD", Snacks.picker.diagnostics, { desc = "[S]earch [D]iagnostics all" })
            vim.keymap.set("n", "<leader>sr", Snacks.picker.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "<leader>sr", Snacks.picker.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "grr", Snacks.picker.lsp_references)
            vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions)
            vim.keymap.set("n", "cs", Snacks.picker.spelling)
        end,
    },

    {
        "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
        event = "VeryLazy",
        config = function()
            local rainbow_delimiters = require("rainbow-delimiters")

            vim.g.rainbow_delimiters = {
                strategy = {
                    [""] = rainbow_delimiters.strategy["global"],
                    vim = rainbow_delimiters.strategy["local"],
                },
                query = {
                    [""] = "rainbow-delimiters",
                    lua = "rainbow-blocks",
                },
                highlight = {
                    "RainbowDelimiterYellow",
                    "RainbowDelimiterViolet",
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterCyan",
                    "RainbowDelimiterRed",
                },
            }
        end,
    },
}
