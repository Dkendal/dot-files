local function hi(group, s)
	return table.concat({ "%#", group, "#", s, "%#StatusLine#" }, "")
end

_G.user_status_line = {}

function _G.user_status_line.mode()
	return vim.api.nvim_get_mode().mode
end

function _G.user_status_line.macro()
	local reg = vim.fn.reg_recording()

	if reg == "" then
		return ""
	end

	return table.concat({ "[%#MiniIconsRed#⬤", vim.fn.reg_recording(), "%#StatusLine#]" }, "")
end

function _G.user_status_line.diagnostics()
	local count = vim.diagnostic.count(0)

	if vim.tbl_isempty(count) then
		return ""
	end

	local i = 0
	local s = {
		"["
	}

	-- pre size array
	s[14] = nil

	i = count[vim.diagnostic.severity.ERROR]
	if i ~= nil then
		table.insert(s, "%#StatusLineDiagnosticError#")
		table.insert(s, "E:")
		table.insert(s, i)
	end

	i = count[vim.diagnostic.severity.WARN]
	if i ~= nil then
		table.insert(s, "%#StatusLineDiagnosticWarn#")
		table.insert(s, "W:")
		table.insert(s, i)
	end

	i = count[vim.diagnostic.severity.INFO]
	if i ~= nil then
		table.insert(s, "%#StatusLineDiagnosticInfo#")
		table.insert(s, "I:")
		table.insert(s, i)
	end

	i = count[vim.diagnostic.severity.HINT]
	if i ~= nil then
		table.insert(s, "%#StatusLineDiagnosticHint#")
		table.insert(s, "H:")
		table.insert(s, i)
	end

	table.insert(s, "%#StatusLine#]")

	return table.concat(s, "")
end

local function setup()
	vim.api.nvim_create_autocmd({ "ColorScheme" }, {
		pattern = "*",
		callback = function()
			local hl = require("user.highlight")
			local colors = hl.color_map()
			local StatusLine = hl.get(0, { name = "StatusLine" })
			hl.set(0, "StatusLineDiagnosticError", { bg = StatusLine.bg, fg = colors.Red, bold = true })
			hl.set(0, "StatusLineDiagnosticWarn", { bg = StatusLine.bg, fg = colors.Orange, bold = true })
			hl.set(0, "StatusLineDiagnosticHint", { bg = StatusLine.bg, fg = colors.Blue, bold = true })
			hl.set(0, "StatusLineDiagnosticInfo", { bg = StatusLine.bg, fg = colors.Cyan, bold = true })
		end
	})

	vim.o.statusline =
	[[%{ v:lua.user_status_line.mode() } %f%s%h%r%w%q %=  %{% v:lua.user_status_line.diagnostics() %}%{% v:lua.user_status_line.macro() %} %l,%c %P]]
	vim.o.winbar = "%#StatusLine#%f"
end

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "VeryLazy",
	callback = setup
})
