local gitsigns = require("gitsigns")
local map = vim.keymap.set
local opts = { buffer = true }

map("n", "]c", gitsigns.next_hunk, opts)
map("n", "[c", gitsigns.prev_hunk, opts)
map("n", "<space>hs", gitsigns.stage_hunk, opts)
map("n", "<space>hb", gitsigns.stage_hunk, opts)
map("n", "<space>hp", gitsigns.preview_hunk, opts)
map("n", "<space>hS", gitsigns.select_hunk, opts)
map("n", "<space>h!", gitsigns.reset_hunk, opts)
