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
        jai = "jai",
    },
})

vim.g.lolo_lsp_loaded = false

local function load_lsp()
    if vim.g.lolo_lsp_loaded then
        return
    end
    vim.g.lolo_lsp_loaded = true

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

    local client = vim.lsp.get_client_by_id(client_id)
    if client and client:supports_method("textDocument/documentColor") then
        pcall(vim.lsp.document_color.enable, true, { bufnr = buf, id = client_id }, { style = "virtual" })
    end

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


-- svelte lsp gets confused over paths being slightly different
-- this normalizes the buffer name to be consistent
local function normpath(path)
    if not path or path == "" then
        return path
    end
    path = vim.fs.normalize(path)
    path = path:gsub("\\", "/")
    if path:match("^%a:") then
        path = path:sub(1, 1):lower() .. path:sub(2)
    end
    return path:lower()
end

local function normalize_buffer_name(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
        return
    end

    local real = vim.uv.fs_realpath(name) or name
    local normalized = normpath(real)
    if normalized ~= "" and normalized ~= name then
        pcall(vim.api.nvim_buf_set_name, bufnr, normalized)
    end
end

vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("lolo_normalize_buffer_name", { clear = true }),
    callback = function(event)
        normalize_buffer_name(event.buf)
    end,
})
