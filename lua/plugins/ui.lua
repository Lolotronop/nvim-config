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
                { "<leader>r", group = "[R]ename" },
                { "<leader>s", group = "[S]earch" },
                { "<leader>w", group = "[W]orkspace" },
            })
        end,
    },

    { -- Fuzzy Finder (files, lsp, etc)
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for install instructions
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-tree/nvim-web-devicons" },
        },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            -- See `:help telescope.builtin`
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

            -- Also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            vim.keymap.set("n", "<leader>s/", function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                })
            end, { desc = "[S]earch [/] in Open Files" })

            -- Shortcut for searching your neovim configuration files
            vim.keymap.set("n", "<leader>sn", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "[S]earch [N]eovim files" })
        end,
    },

    {
        "luisiacc/gruvbox-baby",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_baby_telescope_theme = 1
            vim.g.gruvbox_baby_keyword_style = "bold"
            vim.g.gruvbox_baby_comment_style = "altfont"
            vim.g.gruvbox_baby_background_color = "dark"
            vim.g.gruvbox_baby_transparent_mode = 1
            vim.cmd([[colorscheme gruvbox-baby]])

            vim.cmd("highlight! BlinkCmpMenu guibg=#1d2021 ctermbg=NONE")
            vim.cmd("highlight! BlinkCmpMenuSelection guibg=#3c3836 ctermbg=NONE")

            vim.cmd("highlight! SnacksIndentScope guifg=#665c54 ctermbg=NONE")
            vim.cmd("highlight! SnacksIndent guifg=#282828 ctermbg=NONE")

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
            }
            require("snacks").setup(opts)
            vim.keymap.set("n", "<leader>nh", function()
                require("snacks").notifier.show_history()
            end, { desc = "Snack" })
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
