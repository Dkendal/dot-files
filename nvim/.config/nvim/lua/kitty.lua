local lfs = require 'lfs'
local a = require 'async'
local action = require'fzf.actions'.action
local fzf = require'fzf'.fzf
local V = require 'vim'
local enum = require 'enum'

local cmd = vim.cmd
local api = vim.api
local fn = vim.fn
local assign = vim.tbl_extend
local flatten = vim.tbl_flatten
local filter = function(tbl, f)
  return vim.tbl_filter(f, tbl)
end
local map = function(tbl, f)
  return vim.tbl_map(f, tbl)
end

local Mod = {}

vim.g.bat_theme = { dark = 'gruvbox-dark', light = 'gruvbox-light' }

local function bat_theme()
  return vim.g.bat_theme[vim.o.background]
end

-- Create a new window for the buffer
local function openbuf(buf)
  if fn.bufwinnr(buf) == -1 then
    cmd(F('vertical botright sb ${buf}', { buf = buf }))
  end
end

local function getbuf()
  local name = '[Kitty Output]'

  local buf = nil

  if fn.bufexists(name) == 0 then
    buf = api.nvim_create_buf(true, true)
    api.nvim_buf_set_name(buf, name)
    api.nvim_buf_set_option(buf, 'swapfile', false)
    api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    api.nvim_buf_set_option(buf, 'buflisted', true)
    api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
  else
    buf = fn.bufnr(name)
  end

  if (buf == -1) then
    error('couldn\'t create buffer')
  end

  return buf
end

local function shell(command)
  local handle = io.popen(command)
  local result = handle:read('*a')
  handle:close()
  return vim.trim(result)
end

function Mod.capture()
  local buf = getbuf()
  local title = 'vim-test-output'
  local extent = 'screen'
  local opts = '--extent=${extent} --match title:${title}' % { title = title, extent = extent }
  local shellcmd = 'kitty @ get-text ' .. opts

  api.nvim_buf_set_lines(buf, 0, -1, false, {})

  fn.jobstart(shellcmd, {
    on_stdout = function(_, data, _)
      api.nvim_buf_set_lines(buf, -1, -1, false, data)
    end,

    on_exit = function(_, _, _)
      local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
      local qflist = fn.getqflist({ lines = lines }).items

      qflist = filter(qflist, function(item)
        return item.valid == 1
      end)

      local source = map(qflist, function(item)
        local file = vim.fn.bufname(item.bufnr)
        local result = locate('.', file)

        if result ~= '' then
          file = result
          item.file = file
          item.bufnr = fn.bufadd(file)
        end

        item = assign('keep', item, { file = file })
        return '${file}:${lnum}:\t${text}' % item
      end)

      local source_t = enum.transpose_index(source)

      -- Start FZF
      a.sync(function()
        local color = vim.o.background

        local preview = action(function(selection, fzf_lines, col)
          local item = qflist[source_t[selection[1]]]
          local file = item.file
          local lnum = item.lnum
          local lrange = math.max(math.floor(lnum - fzf_lines / 2), 0)

          local preview = table.concat({
            'bat',
            '--color=always',
            '--italic-text=always',
            '--style=changes,numbers',
            '--theme=' .. bat_theme(),
            '--highlight-line=' .. lnum,
            '--line-range=' .. lrange .. ':',
            '--',
            file
          }, ' ')

          return shell(preview)
        end)

        local fzf_opts = table.concat({
          '--ansi',
          '--delimiter=:',
          '--ansi',
          '--color=' .. color,
          '--preview=' .. preview
        }, ' ')

        local result = fzf(source, fzf_opts)

        local selection = result[1]
        selection = vim.split(selection, ':')

        cmd('edit +${lnum} ${file}' % { file = selection[1], lnum = selection[2] })
      end)()
    end
  })
end

function dirtree(dirname, opts)
  opts = opts or {}
  local depth = opts.depth or 1
  local hidden = opts.hidden or false

  local items = vim.fn.readdir(dirname, function(f)
    if (f[1] == '.') then
      return false
    end

    local path = dirname .. '/' .. f

    local stat = lfs.attributes(path)

    if stat and stat.mode == 'directory' then
      return true
    end

    return false
  end)

  for index, value in ipairs(items) do
    items[index] = dirname .. '/' .. value
  end

  if depth > 1 then
    opts.depth = depth - 1

    local children = map(items, function(item)
      return dirtree(item, opts)
    end)

    items[#items + 1] = children
    items = flatten(items)
  end

  return items
end

-- Find a file based on a partial path
function locate(dir, file)
  local dirs = dirtree(dir, { depth = 2 })
  dirs = table.concat(dirs, ',')
  return vim.fn.globpath(dirs, file)
end

function Mod.init()
  local call = V.bind('kitty')

  V.nmap('<leader>ko', call('capture'), { nowait = true })
end

Mod.init()

return Mod
