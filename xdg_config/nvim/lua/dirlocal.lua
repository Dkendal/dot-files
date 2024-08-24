local fun = require("fun")
local config = {}
local dirlocal = {}
dirlocal.dirchanged = function(event)
  return inspect(event)
end
dirlocal.setup = function(conf)
  config = conf
  return nil
end
dirlocal.get_config = function()
  return config
end
local function augroup(name, ...)
  return vim.api.nvim_exec(table.concat({("augroup " .. name), "autocmd!", table.concat({...}, "\n"), "augroup END"}, "\n"), false)
end
local function au(events, pattern, mod, fun0)
  local events0 = nil
  do
    local _0_0 = type(events)
    if (_0_0 == "table") then
      events0 = table.concat(events, ",")
    elseif (_0_0 == "string") then
      events0 = events
    else
    events0 = nil
    end
  end
  local body = ("lua require('" .. mod .. "')." .. fun0 .. "(vim.deepcopy(vim.v.event))")
  return table.concat({"exe", "\"", "autocmd", events0, pattern, body, "\""}, " ")
end
return dirlocal
