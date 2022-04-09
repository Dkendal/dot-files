local M = {}

-- local function set_default(t, constructor)
--   local mt = {
--     __index = function(_, key)
--       local value = constructor()
--       t[key] = value
--       return value
--     end,
--   }
--   setmetatable(t, mt)
-- end

local config = {
  use_whichkey = false,
}

local callbacks = {}
local filetype_keymaps = {}
local buffer_keymaps = {}
local hooks = {}

-- set_default(hooks, function() return {} end)

function M.call(cb_name)
  local cb = callbacks[cb_name]
  cb()
end

local function register_binding(mode, binding, cmd, filetype)
  filetype = filetype or "global"
  local key = string.format("%s :: %s :: %s", filetype, mode, binding:gsub("[/<>]", "/%0"))
  callbacks[key] = cmd
  return string.format([[:lua require("user.general").call(%q)<cr>]], key)
end

function M.remove_hook(name)
  hooks[name] = nil
end

function M.add_hook(name, callback)
  local hook = hooks[name] or {}
  hooks[name] = hook

  if type(callback) == "function" then
    table.insert(hook, callback)
    return
  end

  if type(callback) ~= "string" then
    vim.api.nvim_err_writeln("add_hook accepts either a function or then name of a global function as a callback")
    return
  end
  -- -- Don't re-add a hook if it's already present
  -- for _, value in pairs(hook) do
  --   if value == callback then
  --     return
  --   end
  -- end
  table.insert(hook, callback)
end

function M.call_hook(name)
  local hook = hooks[name] or {}
  for _, value in pairs(hook) do
    if type(value) == "function" then
      value()
    elseif type(value) == "string" then
      local cb = _G[value]
      if type(cb) == "function" then
        cb()
      else
        vim.api.nvim_err_writeln("Expected " .. value .. " to be a global function")
      end
    end
  end
end

local function set_map(filetype, mode, lhs, rhs, label, opts)
  -- Append multiple values together
  if type(rhs) == "table" then
    local acc = {}
    for _, value in ipairs(rhs) do
      if type(value) == "function" then
        value = register_binding(mode, lhs, value, filetype or "global")
      end
      table.insert(acc, value)
    end
    rhs = table.concat(acc)
  else
    if type(rhs) == "function" then
      rhs = register_binding(mode, lhs, rhs, filetype or "global")
    end
  end

  local map = filetype_keymaps[filetype] or {}

  filetype_keymaps[filetype] = map

  map[{ mode, lhs }] = {
    mode = mode,
    lhs = lhs,
    rhs = rhs,
    keymap_opts = opts or {},
    label = label,
  }
end

function M.map(opts)
  local mode = opts.mode or "n"
  local filetype = opts.filetype
  local keymap_opts = opts.opts
  local maps = opts.maps

  if opts.lhs and opts.rhs then
    local lhs = opts.lhs
    local rhs = opts.rhs
    local label = opts.label

    set_map(filetype, mode, lhs, rhs, label, keymap_opts)
    return
  end

  if maps then
    for _, local_opts in ipairs(maps) do
      set_map(filetype, local_opts.mode or mode, local_opts.lhs, local_opts.rhs, local_opts.label, keymap_opts)
    end
  end
end

function M.install_buffer_keymaps()
  local keymap = filetype_keymaps[vim.bo.filetype]
  if not keymap then
    return
  end

  for _, mapping in pairs(keymap) do
    if config.use_whichkey then
      require("which-key").register({
        [mapping.lhs] = { mapping.rhs, mapping.label or mapping.rhs },
      }, { mode = mapping.mode })
    else
      vim.api.nvim_buf_set_keymap(0, mapping.mode, mapping.lhs, mapping.rhs, mapping.keymap_opts)
    end
  end
end

function M.setup(options)
  hooks = {}
  callbacks = {}
  filetype_keymaps = {}

  for key, value in pairs(options) do
    config[key] = value
  end

  vim.cmd([[
    augroup user_general
    au!
    au FileType * lua require("user.general").install_buffer_keymaps()
    au FileType * lua require("user.general").call_hook(string.format("%s-filetype", vim.bo.filetype))
    augroup END
  ]])
end

return M
