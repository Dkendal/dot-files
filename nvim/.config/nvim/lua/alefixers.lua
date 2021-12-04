Alefixers = {}

local vim = vim
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

function Alefixers.dprint(buffer)
  return { command = 'dprint fmt %t', read_temporary_file = true }
end

function Alefixers.luaformat(buffer)
  return {
    command = 'lua-format %t'
    -- read_temporary_file = true,
  }
end

function Alefixers.init()
  export('alefixers', 'dprint')
  export('alefixers', 'luaformat')
end

return Alefixers
