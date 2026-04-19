local install_dir = vim.fn.stdpath("data") .. "/site"
local jai_parser_path = vim.fs.normalize("D:/soft/jai/tree-sitter-jai")
local parsers = {
    "bash",
    "c",
    "diff",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "printf",
    "python",
    "query",
    "regex",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "svelte",
    "css",
    "jai",
}

vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/windwp/nvim-ts-autotag",
})

local function register_jai_parser()
    require("nvim-treesitter.parsers").jai = {
        install_info = {
            path = jai_parser_path,
            queries = "queries",
        },
    }
end

vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = register_jai_parser,
})

register_jai_parser()

require("nvim-treesitter").setup({
    install_dir = install_dir,
})

require("nvim-treesitter").install(parsers)
require("nvim-treesitter-textobjects").setup()
require("nvim-ts-autotag").setup()

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
    callback = function(ev)
        local buf = ev.buf
        local filetype = ev.match

        local language = vim.treesitter.language.get_lang(filetype) or filetype
        if not vim.treesitter.language.add(language) then
            return
        end

        vim.treesitter.start(buf, language)
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            register_jai_parser()
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})

-- got this from here https://pawelgrzybek.com/nvim-incremental-selection/#update-20260309
-- incremental selection
vim.keymap.set({ "x", "o", "n" }, "<C-k>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require("vim.treesitter._select").select_parent(vim.v.count1)
    else
        vim.lsp.buf.selection_range(vim.v.count1)
    end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "x", "o" }, "<C-j>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require("vim.treesitter._select").select_child(vim.v.count1)
    else
        vim.lsp.buf.selection_range(-vim.v.count1)
    end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })
