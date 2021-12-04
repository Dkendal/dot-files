local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local fzf = require 'fzf'

local Mod = {}

local function relpath(from, to)
  s, e = to:find(from)

  if s == 1 then
    return '.' .. string.sub(to, e + 1, -1)
  end

  return to
end

function Mod.clist()
  local list = fn.getqflist()
  local cwd = fn.getcwd()

  local source = {}

  for _, item in pairs(list) do
    if item.valid == 1 then
      local path = api.nvim_buf_get_name(item.bufnr)

      path = relpath(cwd, path)

      local colstr = ''

      if item.col ~= 0 then
        colstr = ':' .. item.col
      end

      local entry = path .. ':' .. item.lnum .. colstr .. ' ' .. item.text

      table.insert(source, entry)
    end
  end

  fzf.run { source = source, sink = 'e', dir = cwd, options = { '--ansi' } }
end

function Mod.init()
  api.nvim_set_keymap('n', t('<leader>cl'), [[<CMD>lua require("clist").clist()<CR>]], { noremap = true })
end

Mod.init()

return Mod
