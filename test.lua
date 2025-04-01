local name = "MiniIconsAzure" -- Replace with your highlight group name
local fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(name)), "fg#")
local bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(name)), "bg#")
print("Highlight: " .. name .. ", FG: " .. (fg or "none") .. ", BG: " .. (bg or "none"))
