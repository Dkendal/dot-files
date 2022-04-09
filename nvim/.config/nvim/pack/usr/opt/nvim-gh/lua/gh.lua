local stringx = require("pl.stringx")
local gh = {}
local history = {}
local api = vim.api
local ex = vim.cmd
local v = vim.fn
local bmap
local function _0_(...)
  return vim.api.nvim_buf_set_keymap(0, ...)
end
bmap = _0_
local function hist_push(s)
  return table.insert(history, s)
end
local function hist_pop()
  return table.remove(history)
end
local function hist_last()
  return history[#history]
end
gh["hist-back"] = function()
  if (#history <= 1) then
    return ex(":q")
  else
    hist_pop()
    return ex(table.concat({"term", "gh", table.unpack(hist_last())}, " "))
  end
end
gh.command = function(...)
  hist_push({...})
  return ex(table.concat({"term", "gh", ...}, " "))
end
gh["next-line"] = function()
  return print("next")
end
local function fnref(name, _3fargs)
  local args = string.gsub(vim.inspect((_3fargs or {})), "%s+", " ")
  return (":lua require('gh')['" .. name .. "'](table.unpack(" .. args .. "))<cr>")
end
gh["pr-view"] = function()
  local pr_num = string.match(api.nvim_get_current_line(), "^%s+#(%d+)")
  if pr_num then
    return ex(("Gh pr view " .. pr_num))
  end
end
gh["pr-diff"] = function()
  local pr_num = string.match(api.nvim_get_current_line(), "^%s+#(%d+)")
  if pr_num then
    return ex(("Gh pr diff " .. pr_num))
  end
end
local run_pattern = "%s(%d+)$"
local pr_pattern = "^#(%d+)"
gh["run-sub-cmd"] = function(cmd)
  local id = string.match(api.nvim_get_current_line(), run_pattern)
  if id then
    return ex(("Gh " .. string.format(cmd, id)))
  end
end
local function match_current_line(pattern)
  return string.match(api.nvim_get_current_line(), pattern)
end
gh["line-cmd"] = function(pattern, cmd)
  local id = match_current_line(pattern)
  print(id)
  if id then
    return ex(("Gh " .. string.format(cmd, id)))
  end
end
gh.keymap = function()
  local tokens = stringx.split(string.match(v.expand("%:t"), "%d*:(.*)"))
  local opts = {nowait = true, silent = true}
  bmap("n", "q", fnref("hist-back"), opts)
  local _1_ = tokens
  if ((type(_1_) == "table") and ((_1_)[1] == "gh") and ((_1_)[2] == "run") and ((_1_)[3] == "list") and true) then
    local _ = (_1_)[4]
    local sh
    local function _2_(_241)
      return fnref("line-cmd", {run_pattern, _241})
    end
    sh = _2_
    return bmap("n", "<enter>", sh("run view %s"), opts)
  elseif ((type(_1_) == "table") and ((_1_)[1] == "gh") and ((_1_)[2] == "pr") and ((_1_)[3] == "list")) then
    local sh
    local function _2_(_241)
      return fnref("line-cmd", {pr_pattern, _241})
    end
    sh = _2_
    bmap("n", "<enter>", sh("pr view %s --comments"), opts)
    bmap("n", "<enter>", sh("pr view %s --comments"), opts)
    bmap("n", "h", sh("pr --help"), opts)
    bmap("n", "c", sh("pr checks %s"), opts)
    bmap("n", "CC", sh("pr checkout %s"), opts)
    bmap("n", "l", sh("pr list"), opts)
    bmap("n", "d", sh("pr diff %s"), opts)
    return bmap("n", "o", sh("pr view %s --web"), opts)
  elseif ((type(_1_) == "table") and ((_1_)[1] == "gh") and ((_1_)[2] == "pr") and ((_1_)[3] == "status") and true) then
    local _ = (_1_)[4]
    local sh
    local function _2_(_241)
      return fnref("line-cmd", {pr_pattern, _241})
    end
    sh = _2_
    bmap("n", "<enter>", sh("pr view %s --comments"), opts)
    bmap("n", "h", sh("pr --help"), opts)
    bmap("n", "c", sh("pr checks %s"), opts)
    bmap("n", "CC", sh("pr checkout %s"), opts)
    bmap("n", "l", sh("pr list"), opts)
    bmap("n", "d", sh("pr diff %s"), opts)
    bmap("n", "o", sh("pr view %s --web"), opts)
    return bmap("n", "n", fnref("next-line"), opts)
  end
end
gh.reviews = function()
  local api_query = "is:pr is:open archived:false sort:updated-desc review-requested:Dkendal"
  local template = "{{range .items}}{{.user.login | color \"blue\"}} {{.title | color \"green\"}}{{\"\\n\t\"}}{{ .html_url}}{{\"\\n\"}}{{end}}"
  return ex(("Gh api -X GET search/issues -f q='" .. api_query .. "' --template '" .. template .. "'"))
end
gh.complete_gh = function(arg_lead, cmd_line, cursor_pos)
  local tokens = vim.split(string.sub(cmd_line, 0, cursor_pos), " +")
  local _2_
  do
    local _1_ = tokens
    if ((type(_1_) == "table") and ((_1_)[1] == "Gh") and ((_1_)[2] == "gist")) then
      _2_ = {"clone", "create", "delete", "edit", "list", "view"}
    elseif ((type(_1_) == "table") and ((_1_)[1] == "Gh") and ((_1_)[2] == "issue")) then
      _2_ = {"close", "comment", "create", "delete", "edit", "list", "reopen", "status", "transfer", "view"}
    elseif ((type(_1_) == "table") and ((_1_)[1] == "Gh") and ((_1_)[2] == "pr")) then
      _2_ = {"checkout", "checks", "close", "comment", "create", "diff", "edit", "list", "merge", "ready", "reopen", "review", "status", "view"}
    elseif ((type(_1_) == "table") and ((_1_)[1] == "Gh") and ((_1_)[2] == "repo")) then
      _2_ = {"clone", "create", "fork", "list", "view"}
    elseif ((type(_1_) == "table") and ((_1_)[1] == "Gh") and ((_1_)[2] == "run")) then
      _2_ = {"download", "list", "rerun", "view", "watch"}
    elseif ((type(_1_) == "table") and ((_1_)[1] == "Gh") and ((_1_)[2] == "workflow")) then
      _2_ = {"disable", "enable", "list", "run", "view"}
    elseif ((type(_1_) == "table") and ((_1_)[1] == "Gh")) then
      _2_ = {"gist", "issue", "pr", "release", "repo", "actions", "run", "workflow", "alias", "api", "auth", "completion", "config", "help", "secret", "ssh-key"}
    else
    _2_ = nil
    end
  end
  return table.concat(_2_, "\n")
end
gh.setup = function()
  return ex("\n        augroup nvim-gh\n        au!\n        au TermOpen term://*:gh* lua require'gh'.keymap()\n        augroup END\n        command! -nargs=* -complete=custom,v:lua.require'gh'.complete_gh Gh :lua require'gh'.command(<f-args>)\n        command! -nargs=* GhReviews :lua require'gh'.reviews()\n        ")
end
return gh
