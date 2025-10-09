---@type OrgLinkType
return {
  get_name = function()
    return "jira"
  end,
  follow = function(_self, link)
    if not vim.startswith(link, "jira:") then
      return false
    end

    link = string.match(link, "jira:(%w+-%d+)")
    vim.ui.open("https://blvd.atlassian.net/browse/" .. link)
    return true
  end,
  autocomplete = function()
    return {}
  end,
}
