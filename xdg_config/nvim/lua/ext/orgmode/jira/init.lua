---Callback function for prewalk traversal
---@alias PrewalkCallback fun(node: TSNode, parent: TSNode?, depth: integer): boolean?
---Return false to skip visiting children of this node

---@param node TSNode The root node to start traversal from
---@param callback PrewalkCallback Function called for each node. Return false to skip children
---@param parent TSNode? The parent node (used internally during recursion)
---@param depth integer? The current depth in the tree (default: 0)
---@return nil
local function prewalk(node, callback, parent, depth)
  depth = depth or 0

  -- Visit current node (pre-order)
  local result = callback(node, parent, depth)

  -- If callback returns false, skip children
  if result == false then
    return
  end

  -- Recursively visit children
  for child, field_name in node:iter_children() do
    prewalk(child, callback, node, depth + 1)
  end
end

local function node_to_sexpr(node, bufnr)
  bufnr = bufnr or 0

  local function sexpr_helper(n, depth)
    local node_type = n:type()
    local child_count = n:child_count()

    if child_count == 0 then
      -- Leaf node - include the text content
      local text = vim.treesitter.get_node_text(n, bufnr)
      -- Escape special characters in text
      text = text:gsub('"', '\\"'):gsub('\n', '\\n')
      return string.format('(%s "%s")', node_type, text)
    else
      -- Non-leaf node - recursively process children
      local parts = { "(" .. node_type }

      for i = 0, child_count - 1 do
        local child = n:child(i)
        if child then
          table.insert(parts, sexpr_helper(child, depth + 1))
        end
      end

      table.insert(parts, ")")
      return table.concat(parts, " ")
    end
  end

  return sexpr_helper(node, 0)
end

-- Usage example:
local function print_node_sexpr()
  local node = vim.treesitter.get_node()
  if node then
    local sexpr = node_to_sexpr(node)
    print(sexpr)
  else
    print("No node under cursor")
  end
end

-- You can call it like:
-- :lua print_node_sexpr()
local function node_to_sexpr_pretty(node, bufnr)
  bufnr = bufnr or 0

  local function sexpr_helper(n, depth)
    local indent = string.rep("  ", depth)
    local node_type = n:type()
    local child_count = n:child_count()

    if child_count == 0 then
      local text = vim.treesitter.get_node_text(n, bufnr)
      text = text:gsub('"', '\\"'):gsub('\n', '\\n')
      return string.format('(%s "%s")', node_type, text)
    else
      local parts = { "(" .. node_type }

      for i = 0, child_count - 1 do
        local child = n:child(i)
        if child then
          table.insert(parts, "\n" .. indent .. "  " .. sexpr_helper(child, depth + 1))
        end
      end

      table.insert(parts, ")")
      return table.concat(parts, "")
    end
  end

  return sexpr_helper(node, 0)
end
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

  local todo_status = "TODO"

  if fields.statusCategory == "DONE" then
    todo_status = "DONE"
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
    todo_status = todo_status,
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
