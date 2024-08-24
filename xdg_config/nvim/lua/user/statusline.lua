local M = {}

local function eval_expr(s)
	return "%{" .. s .. "}"
end

local function re_eval_expr(s)
	return "%{%" .. s .. "%}"
end

local function hi(group, s)
	return "%#" .. group .. "#" .. s .. "%#StatusLine#"
end

local sep = "%="

_G.user_status_line = {}

function _G.user_status_line.mode()
	return vim.api.nvim_get_mode().mode
end

function _G.user_status_line.macro()
	local reg = vim.fn.reg_recording()
	if reg == "" then
		return ""
	end
	
	return "[⬤" .. vim.fn.reg_recording() .. "]"
end

function _G.user_status_line.dev_icon()
	local ext = vim.fn.expand("%:e")
	local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(ext, { default = true })
	return hi("StatusLine" .. hl, icon)
end

local function spinner(idx)
	local spinners = {
		"⠋",
		"⠙",
		"⠹",
		"⠸",
		"⠼",
		"⠴",
		"⠦",
		"⠧",
		"⠇",
		"⠏",
	}

	return spinners[idx % #spinners + 1]
end

function _G.user_status_line.lsp()
	local s = ""
	local ls = require("lsp-status")
	local bufnr = vim.api.nvim_get_current_buf()

	local buf_diagnostics = ls.diagnostics(bufnr)
	local buf_messages = ls.messages()

	if #buf_messages > 0 then
		local msg = buf_messages[1]

		if msg.spinner then
			s = s .. spinner(msg.spinner) .. " "
		end

		s = s .. msg.title .. " "

		if msg.progress and msg.percentage then
			s = s .. string.format("(%.0f%%%%) ", msg.percentage)
		end
	end

	if buf_diagnostics.hints > 0 then
		s = s .. hi("StatusLineDiagnosticHint", string.format("H:%d", buf_diagnostics.hints))
	end

	if buf_diagnostics.errors > 0 then
		s = s .. " " .. hi("StatusLineDiagnosticError", string.format("E:%d", buf_diagnostics.errors))
	end

	if buf_diagnostics.warnings > 0 then
		s = s .. " " .. hi("StatusLineDiagnosticWarn", string.format("W:%d", buf_diagnostics.warnings))
	end

	if buf_diagnostics.info > 0 then
		s = s .. " " .. hi("StatusLineDiagnosticInfo", string.format("I:%d", buf_diagnostics.info))
	end

	if s == "" then
		return "✓"
	end

	return s
end

function M.setup()
	local s = ""

	s = s .. re_eval_expr("v:lua.user_status_line.mode()") .. " "
	s = s .. re_eval_expr("v:lua.user_status_line.dev_icon()") .. " "
	s = s .. "%f (%l,%c) %P %h%w%r"
	-- %f = file name
	-- %h = help buffer flag
	-- %w = preview window flag
	-- %r = read-only flag
	-- %l = line number
	-- %c = column number
	-- %V = visual selection
	s = s .. re_eval_expr("v:lua.user_status_line.macro()")
	s = s .. sep .. re_eval_expr("v:lua.user_status_line.lsp()")
	vim.o.statusline = s

	local s = ""
	s = s .. "%f"
	s = hi("StatusLine", s)
	vim.o.winbar = s
end

return M
