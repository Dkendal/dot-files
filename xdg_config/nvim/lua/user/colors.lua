-- DEPRECATED
--
local M = {}

local hi = require("user.hi")

local function tocolor(color)
	if type(color) == "number" then
		color = hi.to_hex(color)
	end
	return hi.hsluv(color)
end

local function get_hl(...)
	local ns, opts
	-- make ns optional
	if select("#", ...) == 1 then
		opts = ...
		ns = 0
	else
		ns, opts = ...
	end

	local hl = vim.api.nvim_get_hl(ns, opts)
	local out = {}
	for key, value in pairs(hl) do
		if key == "link" then
			out[key] = value
		elseif key == "fg" or key == "bg" then
			out[key] = tocolor(value)
		else
			out[key] = value
		end
	end
	return out
end

local function serialize_color(color)
	local out = {}
	for key, value in pairs(color) do
		if key == "link" then
			out[key] = value
		else
			if type(value) == "table" then
				out[key] = value.hex
			else
				out[key] = value
			end
		end
	end
	return out
end

local function set_hl(...)
	local ns, name, opts
	-- make ns optional
	if select("#", ...) == 2 then
		name, opts = ...
		ns = 0
	else
		ns, name, opts = ...
	end

	vim.api.nvim_set_hl(ns, name, serialize_color(opts))
end

local function get_color_map()
	local cm = vim.api.nvim_get_color_map()
	for name, color in pairs(cm) do
		cm[name] = tocolor(color)
	end
	return cm
end

local autocmd = vim.api.nvim_create_autocmd

local group = vim.api.nvim_create_augroup("UserColorscheme", { clear = true })

-- function M.callback()
-- 	local Normal = get_hl({ name = "Normal" })
-- 	local StatusLine = get_hl({ name = "StatusLine" })
-- 	local SignColumn = get_hl({ name = "SignColumn" })
-- 	local colors = get_color_map()
--
-- 	local gruvbox = setmetatable({}, {
-- 		__index = function(_, key)
-- 			local name = "Gruvbox" .. key
-- 			return get_hl({ name = name }).fg
-- 		end,
-- 	})
--
-- 	local Comment = get_hl({ name = "Comment" })
-- 	Comment.italic = true
-- 	set_hl("Comment", Comment)
--
-- 	if vim.o.background == "dark" then
-- 		set_hl("Visual", { bg = Normal.bg.li(15).de(10) })
-- 	else
-- 		set_hl("Visual", { bg = Normal.bg.da(15).de(10) })
-- 	end
--
-- 	local float_bg = Normal.bg.da(5).de(50)
-- 	set_hl("Pmenu", { bg = float_bg })
-- 	set_hl("FloatBorder", { bg = float_bg, fg = float_bg.darken(10).de(30) })
-- 	set_hl("LspDiagnosticsDefaultHint", { link = "GruvboxBg4" })
--
-- 	for _, name in ipairs({ "Error", "Info", "Warn", "Other", "Hint" }) do
-- 		name = "DiagnosticSign" .. name
-- 		local hl = get_hl({ name = name, link = false })
-- 		hl = vim.tbl_extend("keep", hl, SignColumn)
-- 		set_hl(name, hl)
-- 	end
--
-- 	local function set_diff_hl(from, color_hex, dark, light)
-- 		dark = 80 + (dark or 0)
-- 		light = 20 + (light or 0)
--
-- 		local col = hi.hsluv(color_hex).mix(Normal.bg, 30)
--
-- 		if vim.o.background == "dark" then
-- 			col = col.darken(dark)
-- 		else
-- 			col = col.lighten(light)
-- 		end
--
-- 		set_hl("Diff" .. from, {
-- 			bg = tostring(col),
-- 		})
-- 	end
--
-- 	set_diff_hl("Add", "#00FF00")
-- 	set_diff_hl("Change", "#FFFF00")
-- 	set_diff_hl("Text", "#FFFF00", -5, -10)
-- 	set_diff_hl("Delete", "#FF0000")
--
-- 	-- StatusLine
-- 	for _, conf in pairs(require("nvim-web-devicons").get_icons()) do
-- 		set_hl(string.format("StatusLineDevIcon%s", conf.name), {
-- 			fg = conf.color,
-- 			bg = StatusLine.fg,
-- 		})
-- 	end
--
-- 	-- Diagnostics
-- 	for _, name in ipairs({
-- 		"Hint",
-- 		"Error",
-- 		"Warn",
-- 		"Info",
-- 	}) do
-- 		local Diagnostic = get_hl({ name = "Diagnostic" .. name })
--
-- 		set_hl(
-- 			0,
-- 			string.format("StatusLineDiagnostic%s", name),
-- 			vim.tbl_extend("force", Diagnostic, {
-- 				bg = colors.Black,
-- 			})
-- 		)
--
-- 		set_hl(
-- 			0,
-- 			string.format("DiagnosticSign%s", name),
-- 			vim.tbl_extend("force", Diagnostic, {
-- 				bg = SignColumn.bg,
-- 			})
-- 		)
-- 	end
--
-- 	for _, value in ipairs({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }) do
-- 		set_hl(string.format("StatusLine%s", value), {
-- 			fg = (StatusLine.bg).darken(value * 10),
-- 			bg = (StatusLine.fg).darken(value * 10),
-- 		})
-- 	end
-- end
--
-- M.callback()
--
-- -- Run callback on colorscheme change
-- autocmd("Colorscheme", {
-- 	group = group,
-- 	pattern = { "*" },
-- 	callback = M.callback,
-- })
--
return M
