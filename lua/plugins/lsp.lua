return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        event = "VeryLazy",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            {
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            { "williamboman/mason-lspconfig.nvim" },

            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "L3MON4D3/LuaSnip" },
            { "folke/neodev.nvim",                opts = {} },
            -- { 'j-hui/fidget.nvim',                opts = {}, tag = "legacy" },
        },
        config = function()
            local lsp = require("lsp-zero").preset({})

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
            end)

            require('mason').setup({})
            require('mason-lspconfig').setup({
                -- ensure_installed = {'tsserver', 'rust_analyzer'},
                handlers = {
                    lsp.default_setup,
                },
            })

            -- (Optional) Configure lua language server for neovim
            require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

            -- Svelte lsp does not react to js/ts changes by default
            require("lspconfig").svelte.setup({
                on_attach = function(client)
                    vim.api.nvim_create_autocmd("BufWritePost", {
                        pattern = { "*.js", "*.ts" },
                        callback = function(ctx)
                            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
                        end,
                    })
                end,
            })

            -- postcss is just css now, idk
            vim.filetype.add({
                extension = {
                    postcss = 'css',
                    pcss = 'scss',
                }
            })

            lsp.setup()

            local cmp = require("cmp")
            local cmp_action = require("lsp-zero").cmp_action()

            cmp.setup({
                preselect = "item",
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                sources = {
                    { name = "nvim_lsp", keyword_length = 1 },
                    { name = "path" },
                    { name = "buffer",   keyword_length = 1 },
                    { name = "luasnip",  keyword_length = 1 },
                },
                window = {
                    completion = {
                        winhighlight = "Normal:CmpNormal",
                    },
                },
                mapping = {
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-l>"] = cmp.mapping.complete(),
                    ["<Tab>"] = cmp_action.tab_complete(),
                    ["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
                },
                experimental = {
                    ghost_text = true,
                },
            })
        end,
    },

    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                -- Customize or remove this keymap to your liking
                "<leader>p",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        -- Everything in opts will be passed to setup()
        opts = {
            -- Define your formatters
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                javascript = { { "prettierd", "prettier" } },
            },
            -- Set up format-on-save
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
            -- Customize formatters
        },
        init = function()
            -- If you want the formatexpr, here is the place to set it
            -- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        lazy = false,
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "lua",
            },
            auto_install = false,

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        -- You can optionally set descriptions to the mappings (used in the desc parameter of
                        -- nvim_buf_set_keymap) which plugins like which-key display
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                        -- You can also use captures from other query groups like `locals.scm`
                        ["aS"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                    },
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V",  -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                    include_surrounding_whitespace = true,
                },
            },
        },
    },
}
