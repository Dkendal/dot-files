local a = require("user.async")
local vim = vim

local ex = vim.cmd
local api = vim.api
local fn = vim.fn

local function scratch_buf(name)
	local buf = nil

	if fn.bufexists(name) == 0 then
		buf = api.nvim_create_buf(true, true)
		api.nvim_buf_set_name(buf, name)
		api.nvim_buf_set_option(buf, "swapfile", false)
		api.nvim_buf_set_option(buf, "buftype", "nofile")
		api.nvim_buf_set_option(buf, "buflisted", true)
		api.nvim_buf_set_option(buf, "bufhidden", "")
	else
		buf = fn.bufnr(name)
	end

	if buf == -1 then
		error("couldn't create buffer")
	end

	return buf
end


-- The function is called `t` for `termcodes`.
-- You don't have to call it that, but I find the terseness convenient
function _G.t(str)
	-- Adjust boolean arguments as needed
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.unload(mod)
	if package.loaded[mod] == nil then
		return
	end

	package.loaded[mod] = nil

	collectgarbage("collect")
end

function _G.reload(mod)
	if not mod then
		mod = vim.fn.expand("%:p")
		mod = mod:gsub(".*/lua/(.*).lua", "%1")
		mod = mod:gsub("/", ".")
	end
	unload(mod)
	local m = require(mod)
	if m.setup then
		m.setup()
	end
	return m
end

_G.r = _G.reload

return {}
