return {
    {
        'neovim/nvim-lspconfig',
        build = ":MasonUpdate",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { 'williamboman/mason.nvim', config = true, cmd = "Mason" },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', opts = {}, tag = "legacy" },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },

        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup()
            
            local wk = require("which-key")
            wk.register({
                ["K"] = {vim.lsp.buf.hover, "Hover diagnostics"}
            })
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            require("mason-lspconfig").setup_handlers {
               -- a dedicated handler.
                function (server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                    }
                end
            }
        end
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            require('luasnip.loaders.from_vscode').lazy_load()
            luasnip.config.setup {}

            cmp.setup {
                window = {
                    completion = {
                        border = "rounded",
                        maxheight = 10,
                    }
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-j>'] = cmp.mapping.select_next_item(),
                    ['<C-k>'] = cmp.mapping.select_prev_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-l>'] = cmp.mapping.complete {},
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                },
            }
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        event = { "BufReadPost", "BufNewFile" },
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local opts = {
                highlight = { enable = true },
                indent = { enable = true },
                ensure_installed = {
                    "lua",
                },
                auto_install = false,
            }
            require('nvim-treesitter.configs').setup(opts)
        end
    },
}
