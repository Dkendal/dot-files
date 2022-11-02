local M = {}
local lush = require("lush")
local hl = require("user.hl")
local set_hl = vim.api.nvim_set_hl
local get_hl = vim.api.nvim_get_hl_by_name

local autocmd = vim.api.nvim_create_autocmd

local group = vim.api.nvim_create_augroup("UserColorscheme", { clear = true })

local function tohex(num)
	return string.format("#%x", num)
end

local function tocolor(color)
	return lush.hsluv(tohex(color))
end

function M.callback()
	local Normal = get_hl("Normal", true)
	local SignColumn = get_hl("SignColumn", true)

	local Normal__bg = tocolor(Normal.background)

	local bg = Normal__bg
	local fg = get_hl("GruvboxBg4", true).foreground

	local cm = vim.api.nvim_get_color_map()
	local Red = tocolor(cm.Red)
	local Orange = tocolor(cm.Orange)
	local LightBlue = tocolor(cm.LightBlue)
	local LightGrey = tocolor(cm.LightGrey)

	vim.cmd([[hi Comment gui=italic cterm=italic]])

	if vim.o.background == "dark" then
		set_hl(0, "Visual", { background = bg.lighten(15).desaturate(10).hex })
	else
		set_hl(0, "Visual", { background = bg.darken(15).desaturate(10).hex })
	end

	set_hl(0, "NormalFloat", { background = bg.hex })
	set_hl(0, "FloatBorder", { background = bg.hex, foreground = fg })
	set_hl(0, "LspDiagnosticsDefaultHint", { link = "GruvboxBg4" })
	set_hl(0, "DiagnosticSignError", { background = SignColumn.background })
	set_hl(0, "DiagnosticSignInfo", { background = SignColumn.background })
	set_hl(0, "DiagnosticSignWarn", { background = SignColumn.background })
	set_hl(0, "DiagnosticSignOther", { background = SignColumn.background })
	set_hl(0, "DiagnosticSignHint", { background = SignColumn.background })

	set_hl(0, "DiagnosticError", { foreground = Red.hex, background = bg.mix(Red, 20).saturation(100).darken(80).hex })
	set_hl(
		0,
		"DiagnosticInfo",
		{ foreground = LightBlue.hex, background = bg.mix(LightBlue, 20).saturation(100).darken(80).hex }
	)
	set_hl(
		0,
		"DiagnosticWarn",
		{ foreground = Orange.hex, background = bg.mix(Orange, 20).saturation(100).darken(80).hex }
	)
	set_hl(0, "DiagnosticOther", {})
	set_hl(0, "DiagnosticHint", { foreground = LightGrey.hex })

	local function setDiffHl(from, color, dark, light)
		dark = 80 + (dark or 0)
		light = 20 + (light or 0)

		local col = lush.hsluv(color).mix(tocolor(Normal.background), 30)

		if vim.o.background == "dark" then
			col = col.darken(dark)
		else
			col = col.lighten(light)
		end

		set_hl(0, "Diff" .. from, {
			background = tostring(col),
		})
	end

	setDiffHl("Add", "#00FF00")
	setDiffHl("Change", "#FFFF00")
	setDiffHl("Text", "#FFFF00", -5, -10)
	setDiffHl("Delete", "#FF0000")
end

function M.init()
	vim.g.gruvbox_contrast_dark = "hard"
	vim.cmd.colorscheme "gruvbox"

	autocmd("Colorscheme", {
		group = group,
		pattern = { "*" },
		callback = M.callback,
	})
end

return M
