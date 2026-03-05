---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		{ "nvim-treesitter/playground", lazy = true, cmd = "TSPlaygroundToggle" },
		"rrethy/nvim-treesitter-textsubjects",
		"nvim-treesitter/nvim-treesitter-textobjects"
	},
	init = function()
		local configs = require("nvim-treesitter.configs")

		local setup = configs["setup"]

		setup({
			auto_install = true,
			sync_install = true,
			modules = {},
			ensure_installed = {},
			ignore_install = { 'org', 'typst' },
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
			textsubjects = {
				enable = true,
				prev_selection = ",", -- (Optional) keymap to select the previous selection
				keymaps = {
					["."] = "textsubjects-smart",
					[";"] = "textsubjects-container-outer",
					["i;"] = "textsubjects-container-inner",
				},
			},
			textobjects = {
				select = {
					enable = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						-- For example:
						-- Nushell only
						["aP"] = "@pipeline.outer",
						["iP"] = "@pipeline.inner",

						-- supported in other languages as well
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["aC"] = "@conditional.outer",
						["iC"] = "@conditional.inner",
						["iS"] = "@statement.inner",
						["aS"] = "@statement.outer",
					}, -- keymaps
				}, -- select
			}, -- textobjects
			playground = {
				enable = true,
				disable = {},
				updatetime = 25,
				persist_queries = false,
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
			indent = { enable = true },
			highlight = {
				enable = true,
				custom_captures = {},
				disable = { "git", "gitcommit" },
			},
		})
	end,
}
