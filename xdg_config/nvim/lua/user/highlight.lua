local hsluv = require("vivid.hsluv.type")

---@class Highlight
---@field fg string
---@field bg string

---@class HighlightHSLUV
---@field fg userdata
---@field bg userdata

---@class GetOptions
---@field name string
---@field id number | nil
---@field link string | nil
---@field follow boolean | nil
---@field default Highlight | nil

---@param ns number
---@param opts GetOptions
---@return Highlight
local function get_hl(ns, opts)
  opts = opts or {}

  local hl = vim.api.nvim_get_hl(ns, {
    name = opts.name,
    id = opts.id,
    link = opts.link,
  })

  if vim.tbl_isempty(hl) then
    return opts.default or {}
  end

  if opts.follow and hl.link then
    return get_hl(ns, vim.tbl_extend("force", opts, { name = hl.link }))
  end

  return hl
end

local Highlight = {}

function Highlight:merge(behavior, other)
  return vim.tbl_extend(behavior, self, other)
end

function Highlight:invert()
  return self:merge("force", {
    fg = self.bg,
    bg = self.fg,
  })
end

---@param ns number
---@param opts GetOptions
---@return Highlight
--- Returns the highlight group with the given name or the default value if it doesn't exist
local function get(ns, opts)
  local hl = get_hl(ns, opts)

  local out = {}
  setmetatable(out, { __index = Highlight })

  for key, value in pairs(hl) do
    if ({ fg = true, bg = true })[key] then
      local hex = string.format("#%06x", value)
      value = hsluv(hex)
      out[key] = value
    else
      out[key] = value
    end
  end

  return out
end

local function set(ns, name, opts)
  local out = {}

  for key, value in pairs(opts) do
    if type(value) == "table" then
      out[key] = value.hex
    else
      out[key] = value
    end
  end

  return vim.api.nvim_set_hl(ns, name, out)
end

local function merge(ns, name, opts)
  local hl = get(ns, { name = name, follow = true })
  if not hl then
    return
  end
  hl = hl:merge("force", opts)
  return set(ns, name, hl)
end

local function update(ns, name, fn)
  local hl = get(ns, { name = name, follow = true })
  if not hl then
    return
  end
  hl = fn(hl)
  return set(ns, name, hl)
end

local function color_map()
  local cm = vim.api.nvim_get_color_map()

  for name, value in pairs(cm) do
    local hex = string.format("#%06x", value)
    value = hsluv(hex)
    cm[name] = value
  end

  return cm
end

local M = {
  get = get,
  set = set,
  merge = merge,
  update = update,
  color_map = color_map,
}

setmetatable(M, {
  __index = function(_, key)
    return get(0, { name = key, follow = true })
  end,

  __newindex = function(_, key, value)
    set(0, key, value)
  end,
})

return M
