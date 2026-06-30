vim.pack.add({
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/tpope/vim-sleuth",
})

require("mini.basics").setup()
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("mini.files").setup({
    mappings = {
        go_in = "L",
        go_in_plus = "l",
    },
    windows = {
        preview = true,
        width_preview = 50,
    },
})

vim.keymap.set("n", "<leader>e", function()
    local path = vim.api.nvim_buf_get_name(0)
    if vim.fn.has("win32") then
        -- make the drive letter lowercase
        -- because for whatever reason, leaving it uppercase
        -- causes mini.files to open the file a D:\\file indtead of D:\file
        -- causing svelte lsp to fail
        -- ugh
        path = path:sub(1, 1):lower() .. path:sub(2)
    end
    MiniFiles.open(path)
end, { desc = "[E]xplorer files" })

vim.g.lolo_mini_loaded = false

local function load_mini()
    if vim.g.lolo_mini_loaded then
        return
    end
    vim.g.lolo_mini_loaded = true

    require("mini.diff").setup({
        view = {
            -- style = 'sign',
            signs = { add = "+", change = "~", delete = "-" },
        },
    })

    vim.keymap.set("n", "<leader>g", function()
        MiniDiff.toggle_overlay()
    end)

    require("mini.git").setup()

    require("mini.pairs").setup({
        modes = { insert = true, command = true, terminal = false },
        -- skip autopair when next character is one of these
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        -- skip autopair when the cursor is inside these treesitter nodes
        skip_ts = { "string" },
        -- skip autopair when next character is closing pair
        -- and there are more closing pairs than opening pairs
        skip_unbalanced = true,
        -- better deal with markdown code blocks
        markdown = true,
    })

    local ai = require("mini.ai")
    ai.setup({
        n_lines = 500,
        custom_textobjects = {
            o = ai.gen_spec.treesitter({ -- code block
                a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            }),
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),       -- class
            t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },           -- tags
        },
    })

    require("mini.align").setup()

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

    local statusline = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git = MiniStatusline.section_git({ trunc_width = 40 })
        local diagnostics = MiniStatusline.section_diagnostics({
            trunc_width = 75,
            signs = { ERROR = " ", WARN = " ", HINT = " ", INFO = " " },
        })
        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local location = MiniStatusline.section_location({ trunc_width = 75 })
        local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
            { hl = mode_hl,                 strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git } },
            "%<", -- Mark general truncate point
            { hl = "MiniStatuslineFilename", strings = { filename, diagnostics } },
            "%=", -- End left alignment
            { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
            { hl = mode_hl,                  strings = { search, location } },
        })
    end

    -- TODO: maybe set it up?
    require("mini.statusline").setup({
        content = {
            active = statusline,
            incactive = statusline,
        },
        use_icons = true,
    })

    local miniclue = require("mini.clue")
    miniclue.setup({
        triggers = {
            -- Leader triggers
            { mode = { "n", "x" }, keys = "<Leader>" },

            -- `[` and `]` keys
            { mode = "n",          keys = "[" },
            { mode = "n",          keys = "]" },

            -- Built-in completion
            { mode = "i",          keys = "<C-x>" },

            -- `g` key
            { mode = { "n", "x" }, keys = "g" },

            -- Marks
            { mode = { "n", "x" }, keys = "'" },
            { mode = { "n", "x" }, keys = "`" },

            -- Registers
            { mode = { "n", "x" }, keys = '"' },
            { mode = { "i", "c" }, keys = "<C-r>" },

            -- Window commands
            { mode = "n",          keys = "<C-w>" },

            -- `z` key
            { mode = { "n", "x" }, keys = "z" },
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
            width = "auto",
        },
    })
end

vim.api.nvim_create_autocmd("UIEnter", {
    group = vim.api.nvim_create_augroup("myconf_load_mini", { clear = true }),
    once = true,
    callback = function()
        vim.schedule(load_mini)
    end,
})
