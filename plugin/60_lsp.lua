vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/williamboman/mason-lspconfig.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

vim.filetype.add({
    extension = {
        postcss = "css",
        pcss = "css",
    },
})

local lsp_loaded = false

local function load_lsp()
    if lsp_loaded then
        return
    end
    lsp_loaded = true

    require("mason").setup()
    require("mason-tool-installer").setup({
        ensure_installed = {},
    })
    require("mason-lspconfig").setup({
        handlers = {
            function(server_name)
                vim.lsp.enable(server_name)
            end,
        },
    })
end

vim.api.nvim_create_autocmd("UIEnter", {
    group = vim.api.nvim_create_augroup("myconf_load_lsp", { clear = true }),
    once = true,
    callback = function()
        vim.defer_fn(load_lsp, 100)
    end,
})

local onattach = function(client_id, buf)
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
    vim.lsp.document_color.enable(true, nil, { style = "virtual" })

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

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
        onattach(event.data.client_id, event.buf)
    end,
})
