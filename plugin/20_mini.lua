vim.pack.add({
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/tpope/vim-sleuth",
})

require('mini.basics').setup()

require("mini.diff").setup({
    view = {
        -- style = 'sign',
        signs = { add = '+', change = '~', delete = '-' },
    }
})

require("mini.git").setup()

local spec_treesitter = require("mini.ai").gen_spec.treesitter
require("mini.ai").setup({
    n_lines = 500,
    custom_textobjects = {
        f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
        o = spec_treesitter({
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
        }),
    },
})

require("mini.surround").setup({
    mappings = {
        add = "sa",
        delete = "sd",
        replace = "sr",

        find = "sf",           -- Find surrounding (to the right)
        find_left = "sF",      -- Find surrounding (to the left)
        highlight = "sh",      -- Highlight surrounding
        update_n_lines = "sn", -- Update `n_lines`

        suffix_last = "l",     -- Suffix to search with "prev" method
        suffix_next = "n",     -- Suffix to search with "next" method
    },
})

require("mini.icons").setup()
require("mini.statusline").setup({
})


local miniclue = require('mini.clue')
miniclue.setup({
    triggers = {
        -- Leader triggers
        { mode = { 'n', 'x' }, keys = '<Leader>' },

        -- `[` and `]` keys
        { mode = 'n',          keys = '[' },
        { mode = 'n',          keys = ']' },

        -- Built-in completion
        { mode = 'i',          keys = '<C-x>' },

        -- `g` key
        { mode = { 'n', 'x' }, keys = 'g' },

        -- Marks
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },

        -- Registers
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },

        -- Window commands
        { mode = 'n',          keys = '<C-w>' },

        -- `z` key
        { mode = { 'n', 'x' }, keys = 'z' },
    },

    clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
    },

    window = {
        delay = 500,
    }
})
