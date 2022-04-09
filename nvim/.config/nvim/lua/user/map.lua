local M = {
  __callbacks = {},
  __buffer_callbacks = {},
}

function M.call(cb_name)
  M.__callbacks[cb_name]()
end

local function register(mode, binding, cmd)
  local key = string.format("%s/%s", mode, binding:gsub("[<>]", "/%0"))
  M.__callbacks[key] = cmd
  return string.format([[<cmd>lua require("user.map").call(%q)<cr>]], key)
end

function M.cmd(vimexpr)
  return string.format([[<cmd>%s<cr>]], vimexpr)
end

function M.ref(mod)
  return function(funcname)
    return M.cmd(string.format([[require("%s")["%s"]()]], mod, funcname))
  end
end

function M.bmap(bufnr, mode, binding, cmd, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, binding, cmd, opts)
end

function M.map(mode, binding, cmd, opts)
  opts = opts or {}
  if type(cmd) == "function" then
    cmd = register(mode, binding, cmd)
  end

  vim.api.nvim_set_keymap(mode, binding, cmd, opts)
end

return M
