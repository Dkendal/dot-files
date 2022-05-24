local lush = require("lush")
local hl = require("user.hl")

local autocmd = vim.api.nvim_create_autocmd

local group = vim.api.nvim_create_augroup("UserColorscheme", { clear = true })

local function tohex(num)
	return string.format("#%x", num)
end

local function tocolor(color)
	return lush.hsluv(tohex(color))
end

autocmd("Colorscheme", {
	group = group,
	pattern = { "*" },
	callback = function()
		local Normal = hl.get_hl("Normal")
		local SignColumn = hl.get_hl("SignColumn")
		local bg = tostring(lush.hsluv(Normal.background).lighten(4))
		local fg = tostring(lush.hsluv(Normal.background).lighten(10))

		vim.cmd([[hi! link LspDiagnosticsDefaultHint GruvboxBg4]])
		vim.cmd([[hi Comment gui=italic cterm=italic]])
		-- vim.cmd([[hi NormalFloat ]])
		vim.api.nvim_set_hl(0, "NormalFloat", { background = bg })
		vim.api.nvim_set_hl(0, "FloatBorder", { background = bg, foreground = fg })
		-- vim.cmd([[hi FloatBorder guifg=white guibg=]] .. bg)

		vim.cmd([[hi DiagnosticSignError guibg=]] .. SignColumn.background)
		vim.cmd([[hi DiagnosticSignInfo guibg=]] .. SignColumn.background)
		vim.cmd([[hi DiagnosticSignWarn guibg=]] .. SignColumn.background)
		vim.cmd([[hi DiagnosticSignOther guibg=]] .. SignColumn.background)
		vim.cmd([[hi DiagnosticSignHint guibg=]] .. SignColumn.background)

		Normal = vim.api.nvim_get_hl_by_name("Normal", true)

		local function setDiffHl(from, color, dark, light)
			dark = 80 + (dark or 0)
			light = 20 + (light or 0)

			local col = lush.hsluv(color).mix(tocolor(Normal.background), 30)

			if vim.o.background == "dark" then
				col = col.darken(dark)
			else
				col = col.lighten(light)
			end

			vim.api.nvim_set_hl(0, "Diff" .. from, {
				background = tostring(col),
			})
		end

		setDiffHl("Add", "#00FF00")
		setDiffHl("Change", "#FFFF00")
		setDiffHl("Text", "#FFFF00", -5, -10)
		setDiffHl("Delete", "#FF0000")

		-- require("statusline").init()
	end,
})
