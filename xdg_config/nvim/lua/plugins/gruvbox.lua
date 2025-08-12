--- @type LazyPluginSpec
return {
	"morhetz/gruvbox",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.gruvbox_contrast_dark = "hard"
		vim.g.gruvbox_contrast_light = "medium"
		vim.g.gruvbox_improved_strings = 1
		vim.g.gruvbox_bold = 1
		vim.g.gruvbox_italic = 1
		vim.g.gruvbox_underline = 1
		vim.g.gruvbox_undercurl = 1
		vim.g.gruvbox_number_column = "bg0"
		vim.g.gruvbox_sign_column = "bg1"
		vim.g.gruvbox_color_column = "bg1"
		vim.g.gruvbox_vert_split = "bg0"
		vim.g.gruvbox_italicize_comments = 1
		vim.g.gruvbox_improved_strings = 0
		vim.g.gruvbox_improved_warnings = 1

		vim.api.nvim_create_autocmd({ "ColorScheme" }, {
			pattern = "gruvbox",
			callback = function()
				local hl = require("user.highlight")

				local colors = hl.color_map()
				local Normal = hl.get(0, { name = "Normal" })
				local StatusLine = hl.get(0, { name = "StatusLine" })
				local background = vim.o.background

				hl.SignColumn = Normal

				-- Customization on top of Gruvbox
				hl.set(0, "@module", { link = "Structure" })

				hl.set(0, "@markup.heading.1", { link = "GruvboxRed" })
				hl.set(0, "@markup.heading.2", { link = "GruvBoxGreen" })
				hl.set(0, "@markup.heading.3", { link = "GruvboxYellow" })
				hl.set(0, "@markup.heading.4", { link = "GruvboxBlue" })
				hl.set(0, "@markup.raw.block", { link = "GruvBoxFg4" })

				if background == "dark" then
					hl.set(0, "Visual", { bg = Normal.bg.li(15).de(10) })
				else
					hl.set(0, "Visual", { bg = Normal.bg.da(15).de(10) })
				end

				-- Menus
				local float_bg = Normal.bg.da(5).de(50)
				hl.set(0, "Pmenu", { bg = float_bg })
				hl.set(0, "NormalFloat", { bg = float_bg })
				hl.set(0, "FloatBorder", { bg = float_bg, fg = float_bg.darken(10).de(30) })
				hl.set(0, "LspDiagnosticsDefaultHint", { link = "GruvboxBg4" })

				hl.set(0, "StatusLineDiagnosticError", { bg = StatusLine.fg, fg = colors.DarkRed, bold = true })
				hl.set(0, "StatusLineDiagnosticWarn", { bg = StatusLine.fg, fg = colors.DarkOrange, bold = true })
				hl.set(0, "StatusLineDiagnosticHint", { bg = StatusLine.fg, fg = colors.DarkBlue, bold = true })
				hl.set(0, "StatusLineDiagnosticInfo", { bg = StatusLine.fg, fg = colors.DarkCyan, bold = true })

				-- Web devicons
				for _, conf in pairs(require("nvim-web-devicons").get_icons()) do
					local name = string.format("StatusLineDevIcon%s", conf.name)
					hl.set(0, name, {
						bg = StatusLine.fg,
						fg = conf.color,
					})
				end

				for name, opts in pairs({
					Add = { "#9efaa4", "#00ff00" },
					Change = { "#ccfcff", "#ffff00" },
					Delete = { "#ff614d", "#ff0000" },
					Text = { "#ccfcff", "#ffff00" },
				}) do
					local light, dark = unpack(opts)
					local color = ""

					if background == "dark" then
						color = dark
					else
						color = light
					end

					hl.set(0, "Diff" .. name, { bg = color })
				end

				-- Treesitter Context
				hl.set(0, "TreesitterContextBottom", { underline = true })
			end,
		})
	end,
}
