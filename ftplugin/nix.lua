local config_path = vim.fs.joinpath(vim.fn.getcwd(), "nixd.json")
local settings = {}

if vim.fn.filereadable(config_path) == 1 then
    local contents = table.concat(vim.fn.readfile(config_path), "\n")
    contents = contents:gsub("%${NIXOS_HOST}", function()
        return vim.env.NIXOS_HOST or "${NIXOS_HOST}"
    end)

    local ok, decoded = pcall(vim.json.decode, contents)
    if ok then
        settings = decoded
    else
        vim.notify("Could not parse " .. config_path .. ": " .. decoded, vim.log.levels.ERROR)
    end
end

vim.lsp.config("nixd", {
    settings = settings,
})
vim.lsp.enable("nixd")
