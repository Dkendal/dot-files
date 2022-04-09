local mod = {}
mod.map = function(mode, lhs, rhs, _3fopts)
  return vim.api.nvim_set_keymap(mode, lhs, rhs, (_3fopts or {}))
end
mod.bmap = function(mode, lhs, rhs, _3fopts)
  return vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, (_3fopts or {}))
end
return mod
