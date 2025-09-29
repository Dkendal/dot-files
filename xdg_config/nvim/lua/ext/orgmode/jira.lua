local _ = vim.iter
local M = {}
---
---@class ext.org.jira.JiraIssueFields
---@field parent ext.org.jira.JiraIssueParent?
---@field statusCategory ext.org.jira.JiraStatusCategory
---@field resolution ext.org.jira.JiraResolution?
---@field labels string[]
---@field assignee ext.org.jira.JiraUser?
---@field components ext.org.jira.JiraComponent[]
---@field subtasks ext.org.jira.JiraSubtask[]
---@field reporter ext.org.jira.JiraUser
---@field progress ext.org.jira.JiraProgress
---@field votes ext.org.jira.JiraVotes
---@field worklog ext.org.jira.JiraWorklog
---@field issuetype ext.org.jira.JiraIssueType
---@field project ext.org.jira.JiraProject
---@field resolutiondate string?
---@field watches ext.org.jira.JiraWatches
---@field updated string
---@field description ext.org.jira.JiraDescription?
---@field timetracking table
---@field summary string
---@field environment any?
---@field comment ext.org.jira.JiraComment
---@field statuscategorychangedate string
---@field duedate string?
---@field fixVersions any[]
---@field priority ext.org.jira.JiraPriority
---@field timeestimate integer?
---@field versions any[]
---@field status ext.org.jira.JiraStatus
---@field aggregatetimeestimate integer?
---@field creator ext.org.jira.JiraUser
---@field aggregateprogress ext.org.jira.JiraProgress
---@field timespent integer?
---@field aggregatetimespent integer?
---@field workratio integer
---@field created string
---@field security any?
---@field attachment any[]

---@class ext.org.jira.JiraIssue
---@field expand string
---@field id string
---@field self string
---@field key string
---@field fields ext.org.jira.JiraIssueFields

---@class ext.org.jira.JiraIssueParent
---@field id string
---@field key string
---@field self string
---@field fields ext.org.jira.JiraParentFields

---@class ext.org.jira.JiraParentFields
---@field summary string
---@field status ext.org.jira.JiraStatus
---@field priority ext.org.jira.JiraPriority
---@field issuetype ext.org.jira.JiraIssueType

---@class ext.org.jira.JiraStatus
---@field self string
---@field description string
---@field iconUrl string
---@field name string
---@field id string
---@field statusCategory ext.org.jira.JiraStatusCategory

---@class ext.org.jira.JiraStatusCategory
---@field self string
---@field id integer
---@field key string
---@field colorName string
---@field name string

---@class ext.org.jira.JiraPriority
---@field self string
---@field iconUrl string
---@field name string
---@field id string

---@class ext.org.jira.JiraIssueType
---@field self string
---@field id string
---@field description string
---@field iconUrl string
---@field name string
---@field subtask boolean
---@field hierarchyLevel integer
---@field avatarId integer?

---@class ext.org.jira.JiraResolution
---@field self string
---@field id string
---@field description string
---@field name string

---@class ext.org.jira.JiraUser
---@field self string
---@field accountId string
---@field emailAddress string
---@field avatarUrls ext.org.jira.JiraAvatarUrls
---@field displayName string
---@field active boolean
---@field timeZone string
---@field accountType string

---@class ext.org.jira.JiraAvatarUrls
---@field ["48x48"] string
---@field ["24x24"] string
---@field ["16x16"] string
---@field ["32x32"] string

---@class ext.org.jira.JiraComponent
---@field self string
---@field id string
---@field name string

---@class ext.org.jira.JiraSubtask
---@field id string
---@field key string
---@field self string
---@field fields ext.org.jira.JiraSubtaskFields

---@class ext.org.jira.JiraSubtaskFields
---@field summary string
---@field status ext.org.jira.JiraStatus
---@field priority ext.org.jira.JiraPriority
---@field issuetype ext.org.jira.JiraIssueType

---@class ext.org.jira.JiraProgress
---@field progress integer
---@field total integer

---@class ext.org.jira.JiraVotes
---@field self string
---@field votes integer
---@field hasVoted boolean

---@class ext.org.jira.JiraWorklog
---@field startAt integer
---@field maxResults integer
---@field total integer
---@field worklogs any[]

---@class ext.org.jira.JiraProject
---@field self string
---@field id string
---@field key string
---@field name string
---@field projectTypeKey string
---@field simplified boolean
---@field avatarUrls ext.org.jira.JiraAvatarUrls

---@class ext.org.jira.JiraWatches
---@field self string
---@field watchCount integer
---@field isWatching boolean

---@class ext.org.jira.JiraDescription
---@field type string
---@field version integer
---@field content ext.org.jira.JiraDescriptionContent[]

---@class ext.org.jira.JiraDescriptionContent
---@field type string
---@field content ext.org.jira.JiraDescriptionText[]?

---@class ext.org.jira.JiraDescriptionText
---@field type string
---@field text string

---@class ext.org.jira.JiraComment
---@field comments any[]
---@field self string
---@field maxResults integer
---@field total integer
---@field startAt integer

--- @return nil | ext.org.jira.JiraIssue
local function get_issue(key)
  if type(key) ~= "string" then
    error("expected string")
  end

  local out = vim.system({ "jira", "issue", "view", "--raw", key }):wait()

  if out.code ~= 0 then
    error(out.stderr)
  end

  local buf = out.stdout

  if type(buf) ~= "string" then
    error("expected string")
  end

  --- @type ext.org.jira.JiraIssue | nil
  local issue = vim.json.decode(buf)

  if type(issue) ~= "table" then
    error("expected JSON response")
  end

  return issue
end

--- @param data table
--- @param keys string[]
--- @param default any
--- @return any
local function get_in(data, keys, default)
  if data == nil then
    return default
  end

  if keys == nil or #keys == 0 then
    return data
  end

  local current = data

  for _, key in ipairs(keys) do
    if current == nil then
      return default
    end

    if type(current) ~= "table" then
      return default
    end

    current = current[key]
  end

  return current ~= nil and current or default
end

--- @param issue ext.org.jira.JiraIssue
local function format_issue(issue)
  local fields = issue.fields

  local priority = ""

  if fields.priority == "Highest" then
    priority = "A"
  elseif fields.priority == "High" then
    priority = "A"
  elseif fields.priority == "Medium" then
    priority = "B"
  elseif fields.priority == "Low" then
    priority = "C"
  elseif fields.priority == "Lowest" then
    priority = "C"
  elseif fields.priority == "None" then
    priority = ""
  end

  local scheduled = fields["customfield_10015"]

  if scheduled == vim.NIL then
    scheduled = ""
  end

  local deadline = fields.duedate

  if deadline == vim.NIL then
    deadline = ""
  end

  return {
    key = issue.key,
    priority = priority,
    scheduled = scheduled,
    deadline = deadline,
    summary = issue.fields.summary,
    properties = {
      created = fields.created,
      updated = fields.updated,
      priority = fields.priority.name,
      status = fields.status.name,
      type = fields.issuetype.name,
      type_id = fields.issuetype.id,
      assignee = get_in(fields, { "assignee", "emailAddress" }),
      reporter = get_in(fields, { "reporter", "emailAddress" }),
      parent = get_in(fields, { "parent", "key" }),
      components = _(fields.components):map(function(x) return x.name end):join(", ") or "",
      investment = get_in(fields, { "customfield_10186", "value" })
    }
  }
end

-- local issue = get_issue("COPS-8000")
-- if issue then
--   vim.print(vim.inspect(format_issue(issue)))
-- end
--

function M.get_closest_headline()
  local orgmode = require 'orgmode.api'
  local headline = orgmode.current():get_closest_headline()

  if headline == nil then
    return
  end

  return headline
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

  local issue = get_issue(jira_key)

  if not issue then
    error(string.format("couldn't find issue %s", jira_key))
  end

  local issue_data = format_issue(issue)

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
end

return M
