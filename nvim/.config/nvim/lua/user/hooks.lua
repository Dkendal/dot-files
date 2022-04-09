local M = {
  __hooks = {},
}

function M.get(name)
  return M.__hooks[name]
end

function M.set(name, value)
  M.__hooks[name] = value
end

function M.run(name)
  local callbacks = M.get(name)
  if type(callbacks) == "function" then
    callbacks()
  elseif type(callbacks) == "table" then
    for _, cb in ipairs(callbacks) do
      cb()
    end
  end
end

function M.register(name, callback)
  local List = require("pl.List")
  local list = M.get(name) or List.new({})
  M.set(name, list)
  List.append(list, callback)
end

function M.install_autocommand(name, au)
  vim.cmd(string.format([[au! %s lua require("user.hooks").run(%q)]], au, name))
end

return M
