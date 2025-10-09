local function path()
  local s = vim.g.ext_orgmode_hyperlinks_sources_jira_path

  if type(s) ~= "string" then
    error("expected vim.g.ext_orgmode_hyperlinks_sources_jira_path to be a string")
  end

  return s
end


---@type OrgLinkType
return {
  get_name = function()
    return "people"
  end,
  follow = function(_self, link)
    if not vim.startswith(link, "people:") then
      return false
    end

    local filename = string.match(link, "people:(.*)")
    filename = path() .. filename .. ".org"

    vim.cmd("split " .. filename)

    return true
  end,
  autocomplete = function(_self, _link)
    local result = vim.system({ "fd", "\\.org$", path() }, { text = true }):wait()

    if result.code == 0 then
      return vim.iter(vim.split(result.stdout, "\n"))
          :filter(function(x)
            return vim.trim(x) ~= ""
          end)
          :map(function(x)
            local text = x:gsub("^" .. path(), ""):gsub("%.org$", "")
            return "people:" .. text .. "][" .. text .. "]]"
          end)
          :totable()
    else
      vim.notify(result.stderr, "error")
      return {}
    end
  end,
}
