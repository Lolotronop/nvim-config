return {
    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "saghen/blink.cmp",

            { "j-hui/fidget.nvim", opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

                    map(
                        "<leader>ws",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[W]orkspace [S]ymbols"
                    )

                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                    map("<leader>cs", require("telescope.builtin").spell_suggest, "[C]ode [S]pell")
                    map("<leader>ce", require("telescope.builtin").diagnostics, "[C]ode [E]rors")

                    map("K", vim.lsp.buf.hover, "Hover Documentation")

                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    vim.keymap.set("i", "<C-s>", function()
                        vim.lsp.buf.signature_help()
                    end, { buffer = event.buf, desc = "[S]ignature [H]elp" })

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            vim.filetype.add({
                extension = {
                    postcss = "css",
                    pcss = "css",
                },
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    "${3rd}/luv/library",
                                    unpack(vim.api.nvim_get_runtime_file("", true)),
                                },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                            diagnostics = { disable = { "missing-fields" } },
                        },
                    },
                },
                svelte = {
                    -- Svelte lsp does not react to js/ts changes by default
                    on_attach = function(client)
                        vim.api.nvim_create_autocmd("BufWritePost", {
                            pattern = { "*.js", "*.ts" },
                            group = vim.api.nvim_create_augroup("lolo-svelte-lsp-fix", { clear = true }),
                            callback = function(ctx)
                                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
                            end,
                        })
                    end,
                },
            }

            require("mason").setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua",
            })

            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },

    { -- Autoformat
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
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
        opts = {
            notify_on_error = true,
            -- format_on_save = {
            --     timeout_ms = 500,
            --     lsp_fallback = true,
            -- },
            format_on_save = false,
            lsp_fallback = true,
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                javascript = { "prettierd" },
                typescript = { "prettierd" },
                svelte = { "prettierd" },
                css = { "prettierd" },
                html = { "prettierd" },
            },
        },
    },

    {
        "laytan/tailwind-sorter.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
        build = "cd formatter && npm ci && npm run build",
        event = "VeryLazy",
        config = {
            on_save_enabled = true,
            on_save_pattern = {
                "*.html",
                "*.js",
                "*.jsx",
                "*.tsx",
                "*.twig",
                "*.hbs",
                "*.php",
                "*.heex",
                "*.astro",
                "*.svelte",
            },
        },
    },

    {
        "saghen/blink.cmp",
        dependencies = "rafamadriz/friendly-snippets",
        version = "*",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            completion = {
                menu = {
                    -- TODO: fix transparency on completion menu
                    winblend = 0,
                },
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },
                list = {
                    selection = {
                        preselect = function(ctx)
                            return ctx.mode ~= "cmdline"
                        end,
                    },
                },
            },
            keymap = {
                preset = "default",
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-y>"] = { "select_and_accept" },

                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },

                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },

                ["<C-l>"] = { "snippet_forward", "fallback" },
                ["<C-h>"] = { "snippet_backward", "fallback" },
            },

            appearance = {
                -- use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },

            sources = {
                default = { "lsp", "snippets", "path", "buffer" },
            },
        },
        opts_extend = { "sources.default" },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua" },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-k>",
                        node_incremental = "<C-k>",
                        node_decremental = "<C-j>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                        },
                    },
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    {
        "supermaven-inc/supermaven-nvim",
        event = "VeryLazy",
        config = function()
            require("supermaven-nvim").setup({
                disable_keymaps = true,
            })
            local suggestion = require("supermaven-nvim.completion_preview")
            vim.keymap.set("i", "<c-g>", function()
                suggestion.on_accept_suggestion()
            end)
        end,
    },
}
