return {
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
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

            require("which-key").register({
                ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
                ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
                ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
                ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
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
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
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
                        "TelescopeResult",
                    },
                },
                indent = {
                    -- char = {'┊'},
                    char = "▏",
                },
            })
        end,
    },

    {
        "stevearc/dressing.nvim",
        opts = {},
    },

    {
        "rcarriga/nvim-notify",
        lazy = true,
        keys = {
            {
                "<leader>nd",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all Notifications",
            },
            { "<leader>nl", "<cmd>Telescope notify<cr>", desc = "See notifications" },
        },
        opts = {
            timeout = 6000,
            render = "minimal",
            background_colour = "#000000",
            minimum_width = 10,
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

    { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = { signs = false } },

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
            },
            lsp = {
                progress = {
                    enabled = false,
                },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
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
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
}
