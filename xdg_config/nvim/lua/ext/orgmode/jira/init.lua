local api = require 'ext.orgmode.jira.api'

local M = {}

function M.get_closest_headline()
  local orgmode = require 'orgmode.api'
  local headline = orgmode.current():get_closest_headline()

  if headline == nil then
    return
  end

  return headline
end

function M.test()
  local headline = M.get_closest_headline()

  if headline == nil then
    error("expected headline")
  end

  local source = headline.title
  local pos = headline.position
  local stars = string.rep("*", headline.level)
  local status = "TODO"
  local rep = string.format("%s %s %s", status, stars, "test")
  vim.api.nvim_buf_set_text(0, pos.start_line - 1, 0, pos.end_line - 1, -1, { rep })
  -- vim.print(vim.inspect(text))
end

function M.fetch_issue()
  local headline = M.get_closest_headline()

  if not headline then
    error("headline is nil")
  end

  local jira_key = headline:get_property("custom_id")

  if not jira_key then
    jira_key = headline:get_property("id")

    if not jira_key then
      error("CUSTOM_ID and ID is nil")
    end
  end

  local issue = api.get_issue(jira_key)

  if not issue then
    error(string.format("couldn't find issue %s", jira_key))
  end

  local issue_data = api.format_issue(issue)

  for key, value in pairs(issue_data.properties) do
    headline:set_property(key, value)
  end

  headline:set_property("summary", issue_data.summary)

  if headline.priority ~= "" and issue_data.priority ~= "" then
    headline:set_priority("")
  elseif issue_data.priority ~= "" then
    headline:set_priority(issue_data.priority)
  end

  headline:set_scheduled(issue_data.scheduled)
  headline:set_deadline(issue_data.deadline)

  local pos = headline.position
  local stars = string.rep("*", headline.level, "")
  local summary = issue_data.summary
  local rep = string.format("%s %s %s: %s", stars, issue_data.todo_status, issue_data.key, summary)

  vim.schedule(function()
    vim.api.nvim_buf_set_text(0, pos.start_line - 1, 0, pos.start_line - 1, -1, { rep })
  end)

  vim.notify(string.format("Updated issue: %s", jira_key))
end

return M
