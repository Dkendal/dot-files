local a = require 'async'
local vim = vim

local ex = vim.cmd
local api = vim.api
local fn = vim.fn

local function scratch_buf(name)
  local buf = nil

  if fn.bufexists(name) == 0 then
    buf = api.nvim_create_buf(true, true)
    api.nvim_buf_set_name(buf, name)
    api.nvim_buf_set_option(buf, 'swapfile', false)
    api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    api.nvim_buf_set_option(buf, 'buflisted', true)
    api.nvim_buf_set_option(buf, 'bufhidden', '')
  else
    buf = fn.bufnr(name)
  end

  if (buf == -1) then
    error('couldn\'t create buffer')
  end

  return buf
end

function _G.writelog(lines)
  local buf = scratch_buf('nvim://[Lua Messages]')

  api.nvim_buf_set_lines(buf, -1, -1, false, lines)

  if fn.bufwinnr(buf) == -1 then
    ex('vertical botright ${buf} sb' % { buf = buf })
  end
end

-- utility functions

-- Write a message to the scratch message buffer
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  local str = table.concat(objects, ' ')
  local lines = vim.split(str, '\n')

  a.main(function()
    local buf = scratch_buf('nvim://[Lua Messages]')
    api.nvim_buf_call(buf, function()
      -- append to buffer
      api.nvim_buf_set_lines(0, -1, -1, false, lines)
      -- scroll to the bottom of the buffer
      local n = api.nvim_buf_line_count(0)
      api.nvim_win_set_cursor(0, {n, 0})
    end)
  end)

  return ...
end

function _G.inspect(...)
  print(vim.inspect(...))
  return ...
end

function _G.ins(...)
  print(require("fennelview")(...))
  return ...
end

-- The function is called `t` for `termcodes`.
-- You don't have to call it that, but I find the terseness convenient
function _G.t(str)
  -- Adjust boolean arguments as needed
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- String interpolation
function _G.interpolate(s, tab)
  return (s:gsub('($%b{})', function(w)
    return tab[w:sub(3, -2)] or w
  end))
end

_G.F = interpolate

getmetatable('').__mod = interpolate

function _G.unload(mod)
  if package.loaded[mod] == nil then
    return
  end

  package.loaded[mod] = nil
  _G[mod] = nil
end


function _G.log(...)
  inspect(...)
  dump(...)
  return ...
end

function _G.reload(mod)
  log('reloaded module: ' .. '"' .. mod .. '"')
  unload(mod)
  require(mod)
end

-- Make a function from lua available to vim.
-- assumes that the lua module, and the vim module have the same name, and
-- that the function name is the same.
function _G.export(module, name)
  local vars = { module = module, name = name }

  local template = [[
    function! ${module}#${name}(...) abort
      return luaeval("require'${module}'.${name}")(a:000)
    endfunction
  ]]

  template = interpolate(template, vars)

  ex(template)
end
