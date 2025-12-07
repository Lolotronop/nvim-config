local onattach = function(client_id, buf)
    local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = buf, desc = "LSP: " .. desc })
    end

    map("K", vim.lsp.buf.hover, "Hover Documentation")

    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    vim.keymap.set("i", "<C-s>", function()
        vim.lsp.buf.signature_help()
    end, { buffer = buf, desc = "[S]ignature [H]elp" })

    local client = vim.lsp.get_client_by_id(client_id)
    if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = buf,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = buf,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

return {
    {
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
                    onattach(event.data.client_id, event.buf)
                end,
            })

            vim.filetype.add({
                extension = {
                    postcss = "css",
                    pcss = "css",
                },
            })

            require("mason").setup()
            require("mason-tool-installer").setup({})
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        vim.lsp.enable(server_name)
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
            -- format_after_save = false,
            format_after_save = {
                timeout_ms = 500,
                lsp_fallback = true,
                async = true,
            },
            lsp_fallback = true,
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                javascript = { "prettierd" },
                typescript = { "prettierd" },
                svelte = { "prettierd", "prettier" },
                css = { "prettierd" },
                html = { "prettierd" },
            },
        },
    },

    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "echasnovski/mini.nvim",
        },
        version = "1.*",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            completion = {
                documentation = {
                    auto_show = true,
                },
                menu = {
                    -- TODO: fix transparency on completion menu
                    winblend = 0,
                    draw = {
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return kind_icon
                                end,
                                -- (optional) use highlights from mini.icons
                                highlight = function(ctx)
                                    local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return hl
                                end,
                            },
                            kind = {
                                -- (optional) use highlights from mini.icons
                                highlight = function(ctx)
                                    local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return hl
                                end,
                            },
                        },
                    },
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
                default = { "lazydev", "lsp", "snippets", "path", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },

            fuzzy = {
                implementation = "prefer_rust_with_warning",

                sorts = {
                    function(a, b)
                        if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
                            return
                        end
                        return b.client_name == "emmet_ls"
                    end,
                    -- default sorts
                    "score",
                    "sort_text",
                },
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
                -- disabled because js method chaining is working correctly
                indent = { enable = true, disable = { "typescript", "javascript" } },
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
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
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
