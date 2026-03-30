-- :OpenAllTs — add and load all .ts and .svelte under 'src' into buffers
local function chunk(tbl, n)
    local chunks = {}
    for i = 1, #tbl, n do
        table.insert(chunks, vim.list_slice(tbl, i, math.min(i + n - 1, #tbl)))
    end
    return chunks
end

local function open_all_ts_and_svelte()
    -- collect files
    local ts = vim.fn.globpath("src", "**/*.ts", 0, 1)
    local svelte = vim.fn.globpath("src", "**/*.svelte", 0, 1)
    local files = {}
    for _, f in ipairs(ts) do
        files[#files + 1] = f
    end
    for _, f in ipairs(svelte) do
        files[#files + 1] = f
    end

    -- exclude shadcn UI components under src/lib/components/ui
    local function is_excluded(path)
        path = path:gsub("\\", "/")
        return path:find("/src/lib/components/ui/") ~= nil or path:find("^src/lib/components/ui/") ~= nil
    end
    local filtered = {}
    for _, f in ipairs(files) do
        local excluded = is_excluded(f)
        if not excluded then
            filtered[#filtered + 1] = f
        end
    end
    files = filtered

    if #files == 0 then
        print("No .ts or .svelte files found under src")
        return
    end

    -- avoid duplicate entries
    table.sort(files)
    local uniq = {}
    for i = 1, #files do
        if files[i] ~= files[i - 1] then
            uniq[#uniq + 1] = files[i]
        end
    end
    files = uniq

    -- batch to avoid command-length limits
    local batch_size = 40

    for _, batch in ipairs(chunk(files, batch_size)) do
        -- add to arglist safely
        local escaped = vim.tbl_map(vim.fn.fnameescape, batch)
        vim.cmd("silent argadd " .. table.concat(escaped, " "))

        -- load each file into a hidden buffer so LSP will index it
        for _, filepath in ipairs(batch) do
            -- skip if already loaded
            local bufnr = vim.fn.bufnr(filepath, true)
            if bufnr == -1 then
                -- create buffer and load file into it (no window shown)
                bufnr = vim.api.nvim_create_buf(false, true) -- listed=false, scratch=true
                vim.api.nvim_buf_set_name(bufnr, filepath)
                -- try to read file into buffer
                local ok, _ = pcall(vim.api.nvim_buf_attach, bufnr, false, {})
                vim.cmd(string.format("silent keepalt buffer %s | silent edit %s", bufnr, vim.fn.fnameescape(filepath)))
                -- hide it again
                vim.cmd("bprevious") -- go back to previous buffer/window
            else
                -- ensure buffer is loaded
                if not vim.api.nvim_buf_is_loaded(bufnr) then
                    vim.fn.bufload(bufnr)
                end
            end
            -- give LSP a moment: notify bufread for servers listening
            vim.api.nvim_command("doautocmd User OpenAllTsBufferLoaded")
        end
    end

    -- open first file in current window for convenience
    vim.cmd("silent edit " .. vim.fn.fnameescape(files[1]))
    print(#files .. " files loaded into buffers and added to arglist")
end

vim.api.nvim_create_user_command("Opents", open_all_ts_and_svelte, {})
