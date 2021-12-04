local nvim = require 'nvim'

_G.ftplugin_fennel = {}

function ftplugin_fennel.reload()
    -- reload('')
end

vim.o.lispwords = vim.o.lispwords .. ",setmetatable,describe,it,define-minor-mode"
vim.o.commentstring = ";; %s"

nvim.bmap('', 'H', '[%v%')
nvim.bmap('', 'L', ']%v%')
nvim.bmap('n', '<leader>feR', '<cmd>call v:lua.ftplugin_fennel.reload()<cr>')
