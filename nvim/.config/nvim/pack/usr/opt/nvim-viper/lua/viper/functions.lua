local fzf = require("fzf")
local util = require("viper.util")
local a = require("viper.async")
local remote = require("viper.remote")
local debounce = (require("viper.timers")).debounce
local api = vim.api
local mod = {}
local function present_3f(term)
  return ((term ~= "") and (term ~= nil))
end
local function blank_3f(term)
  return not present_3f(term)
end
local function match_error(value)
  return error(("No matching case for: " .. vim.inspect(value)))
end
local function cmd(...)
  return vim.cmd(table.concat({...}, " "))
end
local function log(...)
  local buf = vim.fn.bufadd("[Lua Messages]")
  local objects = vim.tbl_map(vim.inspect, {...})
  local str = table.concat(objects, " ")
  local lines = vim.split(str, "\n")
  local function _0_()
    local function _1_()
      vim.bo.buflisted = true
      vim.bo.swapfile = false
      vim.bo.buftype = "nofile"
      vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
      local n = vim.api.nvim_buf_line_count(0)
      return vim.api.nvim_win_set_cursor(0, {n, 0})
    end
    return vim.api.nvim_buf_call(buf, _1_)
  end
  a.main(_0_)
  return ...
end
local function merge_fzf_opts(opts)
  return util.tbl2flags(vim.tbl_deep_extend("force", {ansi = true, color = vim.o.background}, opts))
end
local function exec_list(vim_expr)
  return vim.split(api.nvim_exec(vim_expr, true), "[\n\r]")
end
local function parse_fn(pattern)
  local function _0_(text)
    local file, line, col = text:match(pattern)
    return {file, tonumber(line), tonumber(col)}
  end
  return _0_
end
local function parse_ls(text)
  local file = text:match("(%d+).*")
  return file
end
local function parse_vimgrep(text)
  local file, line, col = text:match("^(.+):(%d+):(%d+):")
  return {file, tonumber(line), tonumber(col)}
end
local function result_get(result)
  local _0_ = result
  if ((type(_0_) == "table") and ((_0_)[1] == false) and (nil ~= (_0_)[2])) then
    local reason = (_0_)[2]
    return error(reason)
  elseif ((type(_0_) == "table") and ((_0_)[1] == true) and (nil ~= (_0_)[2])) then
    local value = (_0_)[2]
    return value
  end
end
local function with_cursor(func)
  local view = vim.fn.winsaveview()
  local buf = api.nvim_get_current_buf()
  local win = api.nvim_get_current_win()
  local result = {pcall(func)}
  api.nvim_set_current_win(win)
  api.nvim_set_current_buf(buf)
  vim.fn.winrestview(view)
  return result_get(result)
end
local function with_temp_buf(func)
  local function _0_()
    local buf = api.nvim_create_buf(false, true)
    vim.cmd(("botright sb " .. buf))
    api.nvim_win_set_height(0, 10)
    vim.wo.number = false
    vim.wo.signcolumn = "no"
    local result = {pcall(func)}
    if api.nvim_buf_is_valid(buf) then
      api.nvim_buf_delete(buf, {})
    end
    return result_get(result)
  end
  return with_cursor(_0_)
end
local sink_file = {}
sink_file.expect = {"ctrl-y", "ctrl-t", "ctrl-v", "ctrl-s", "enter"}
sink_file.callback = function(result)
  local _0_ = result
  if ((type(_0_) == "table") and ((_0_)[1] == "ctrl-y") and ((type((_0_)[2]) == "table") and (nil ~= ((_0_)[2])[1]))) then
    local file = ((_0_)[2])[1]
    local function _1_()
      vim.fn.setreg("+", file)
      return vim.fn.setreg("*", file)
    end
    return vim.schedule(_1_)
  elseif ((type(_0_) == "table") and ((_0_)[1] == "ctrl-t") and ((type((_0_)[2]) == "table") and (nil ~= ((_0_)[2])[1]))) then
    local file = ((_0_)[2])[1]
    return cmd("tabe", file)
  elseif ((type(_0_) == "table") and ((_0_)[1] == "ctrl-v") and ((type((_0_)[2]) == "table") and (nil ~= ((_0_)[2])[1]))) then
    local file = ((_0_)[2])[1]
    return cmd("vertical", "split", file)
  elseif ((type(_0_) == "table") and ((_0_)[1] == "ctrl-s") and ((type((_0_)[2]) == "table") and (nil ~= ((_0_)[2])[1]))) then
    local file = ((_0_)[2])[1]
    return cmd("split", file)
  elseif ((type(_0_) == "table") and ((_0_)[1] == "enter") and ((type((_0_)[2]) == "table") and (nil ~= ((_0_)[2])[1]))) then
    local file = ((_0_)[2])[1]
    return cmd("e", file)
  end
end
local function run_fzf(opts)
  local fzf_opts = merge_fzf_opts((opts["fzf-opts"] or {}))
  local sink = opts.sink
  local source = opts.source
  local function current_line()
    local pattern = "> (.*)"
    local out = nil
    for k, v in ipairs(api.nvim_buf_get_lines(0, 0, -3, false)) do
      if out then break end
      local m = string.match(v, pattern)
      if m then
        out = m
      end
    end
    return out
  end
  local function selection_change(raw_line)
    if opts["on-change"] then
      local current_line0
      if opts.process then
        current_line0 = opts.process(raw_line)
      else
        current_line0 = raw_line
      end
      if current_line0 then
        local function _1_()
          vim.b["viper-raw-current-line"] = raw_line
          vim.b["viper-current-line"] = current_line0
          return opts["on-change"](current_line0)
        end
        return vim.schedule(_1_)
      end
    end
  end
  local function body()
    do
      vim.api.nvim_buf_set_keymap(0, "t", "<ESC>", "<C-c>", {})
    end
    if opts.config then
      opts.config()
    end
    util.on_selection_change(debounce(100, selection_change))
    local _2_
    do
      local _1_ = source
      if ((type(_1_) == "table") and ((_1_)[1] == "shell") and (nil ~= (_1_)[2])) then
        local shellcmd = (_1_)[2]
        _2_ = shellcmd
      elseif ((type(_1_) == "table") and ((_1_)[1] == "vim") and (nil ~= (_1_)[2])) then
        local expr = (_1_)[2]
        _2_ = exec_list(expr)
      else
        local _ = _1_
        _2_ = match_error(_)
      end
    end
    return fzf.provided_win_fzf(_2_, fzf_opts)
  end
  local function call()
    local function _1_()
      local _0_ = with_temp_buf(body)
      local function _2_()
        local key = (_0_)[1]
        local selection = (_0_)[2]
        return opts.process
      end
      if (((type(_0_) == "table") and (nil ~= (_0_)[1]) and (nil ~= (_0_)[2])) and _2_()) then
        local key = (_0_)[1]
        local selection = (_0_)[2]
        return {key, opts.process(selection)}
      elseif (nil ~= _0_) then
        local k = _0_
        return k
      end
    end
    return sink(_1_())
  end
  return a.main(a.sync(call))
end
mod.history = function()
  local function _0_(_241)
    return _241:match("^%d+: (.*)")
  end
  return run_fzf({["fzf-opts"] = {expect = sink_file.expect}, process = _0_, sink = sink_file.callback, source = {"vim", "oldfiles"}})
end
mod.files = function(source, _3fopts)
  local opts = (_3fopts or {})
  local process
  do
    local _0_ = {opts.pattern, opts.process}
    if ((type(_0_) == "table") and ((_0_)[1] == nil) and ((_0_)[2] == nil)) then
      local function _1_(_241)
        return {_241}
      end
      process = _1_
    elseif ((type(_0_) == "table") and ((_0_)[1] == nil) and (nil ~= (_0_)[2])) then
      local process0 = (_0_)[2]
      process = process0
    elseif ((type(_0_) == "table") and (nil ~= (_0_)[1]) and true) then
      local pattern = (_0_)[1]
      local _ = (_0_)[2]
      process = parse_fn(pattern)
    else
    process = nil
    end
  end
  return run_fzf({["fzf-opts"] = {expect = sink_file.expect}, process = process, sink = sink_file.callback, source = {"shell", source}})
end
mod.grep = function(source, _3fopts)
  local opts = (_3fopts or {})
  local ns = api.nvim_create_namespace("Viper Grep")
  local hl_group = "Search"
  local win = api.nvim_get_current_win()
  local buf = 0
  local function clear_highlight(buf0)
    return api.nvim_buf_clear_namespace(buf0, ns, 0, -1)
  end
  local function on_change(_0_)
    local _arg_0_ = _0_
    local file = _arg_0_[1]
    local line = _arg_0_[2]
    local col = _arg_0_[3]
    buf = vim.fn.bufadd(file)
    local function _1_()
      return clear_highlight(buf)
    end
    vim.schedule(_1_)
    if (file and line) then
      local function _2_()
        api.nvim_buf_add_highlight(buf, ns, hl_group, (line - 1), 0, -1)
        api.nvim_win_set_buf(win, buf)
        local function _3_()
          vim.fn.setpos(".", {buf, line, col})
          cmd("keepjumps normal zz")
          if blank_3f(vim.bo.filetype) then
            return cmd("filetype detect")
          end
        end
        return vim.api.nvim_buf_call(buf, _3_)
      end
      return vim.schedule(_2_)
    end
  end
  local function sink(resp)
    do
      local _1_ = resp
      if ((type(_1_) == "table") and ((_1_)[1] == "enter") and ((type((_1_)[2]) == "table") and (nil ~= ((_1_)[2])[1]) and (nil ~= ((_1_)[2])[2]) and true)) then
        local file = ((_1_)[2])[1]
        local line = ((_1_)[2])[2]
        local _ = ((_1_)[2])[3]
        cmd("e", ("+" .. line), file)
        cmd("keepjumps", "normal", "zz")
      end
    end
    return clear_highlight()
  end
  return run_fzf({["fzf-opts"] = {expect = {"enter"}}, ["on-change"] = on_change, process = parse_vimgrep, sink = sink, source = {"shell", source}})
end
mod.buffers = function()
  local function on_change(buf)
  end
  local opts
  local function _0_(_241)
    local _1_ = _241
    if ((type(_1_) == "table") and ((_1_)[1] == "enter") and (nil ~= (_1_)[2])) then
      local selection = (_1_)[2]
      return cmd("b", selection)
    end
  end
  opts = {["fzf-opts"] = {expect = {"enter"}}, ["on-change"] = on_change, process = parse_ls, sink = _0_, source = {"vim", "ls"}}
  return run_fzf(opts)
end
return mod
