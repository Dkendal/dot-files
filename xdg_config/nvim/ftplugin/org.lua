local abbr = vim.cmd.abbr
local cabbr = vim.cmd.cabbr
local iabbr = vim.cmd.iabbr

-- vim.wo.wrap = true
vim.wo.linebreak = true

iabbr([[<buffer> <expr> d@ strftime('<%Y-%m-%d %a>')]])
iabbr([[<buffer> <expr> D@ strftime('[%Y-%m-%d %a]')]])
