vim.pack.add({ 'https://github.com/dmtrKovalenko/fff.nvim' })

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
            if not ev.data.active then vim.cmd.packadd('fff.nvim') end
            require('fff.download').download_or_build_binary()
        end
    end,
})

vim.g.fff = {
    lazy_sync = true,
    debug = { enabled = true, show_scores = true },
}

vim.keymap.set('n', '<leader>sf', function() require('fff').find_files() end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', function() require('fff').live_grep() end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sw', function() require('fff').live_grep_under_cursor() end, { desc = '[S]earch by [G]rep' })

vim.keymap.set("v", "<leader>s", function()
    vim.cmd('normal! "zy')
    local selection = vim.fn.getreg("z")
    selection = selection:gsub("\n+$", ""):gsub("^%s+", ""):gsub("%s+$", "")
    require('fff').find_files()
    vim.schedule(function()
        vim.api.nvim_feedkeys(selection, "n", false)
    end)
end, { desc = "Search for selected text with grep" })

require('fff').setup({
    prompt = '> ',
    title = 'FFFiles',
    follow_symlinks = true,
    layout = {
        height = 0.9,
        width = 0.9,
        prompt_position = 'top',
        show_scrollbar = true,
        anchor = 'center',
    },
    preview = {
        enabled = true,
        line_numbers = true,
        wrap_lines = true,
    },
    keymaps = {
        close = '<Esc>',
        select = '<CR>',
        select_split = '<C-s>',
        select_vsplit = '<C-v>',
        select_tab = '<C-t>',
        move_up = { '<Up>', '<C-p>', '<C-k>' },
        move_down = { '<Down>', '<C-n>', '<C-j>' },
        preview_scroll_up = '<C-u>',
        preview_scroll_down = '<C-d>',
        toggle_debug = '<F2>',
        cycle_grep_modes = '<S-Tab>',
        insert_newline_escape = '<C-CR>',
        -- grep mode only: jump cursor to first match of next/prev file group
        grep_jump_to_next_file = { '<C-A-n>', '<A-Down>' },
        grep_jump_to_prev_file = { '<C-A-p>', '<A-Up>' },
        cycle_previous_query = '<C-Up>',
        toggle_select = '<Tab>',
        send_to_quickfix = '<C-q>',
        focus_list = '<leader>l',
        focus_preview = '<leader>p',
    },
    git = {
        status_text_color = false, -- true to color filenames by git status
    },
    file_picker = {
        fuzzy_query_highlighting = false, -- true to highlight fuzzy query matches in file picker results
    },
    grep = {
        max_file_size = 10 * 1024 * 1024,
        max_matches_per_file = 100,
        smart_case = true,
        time_budget_ms = 150,
        modes = { 'fuzzy', 'plain', 'regex', },
        trim_whitespace = false,
        enable_filename_constraint = false, -- treat filename-like tokens (e.g. `score.rs`) in a grep query as a file-path filter scoping the search; off = searched as literal text
        location_format = ':%d:%d',         -- printf format for line:col prefix in grep results, e.g. ':%d' for line-only
    },
})
