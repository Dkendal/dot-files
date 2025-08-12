---@module 'blink.cmp'
---@type blink.cmp.Config
local opts = {
	snippets = { preset = "mini_snippets" },
	fuzzy = {
		implementation = "prefer_rust_with_warning"
	},
	completion = {
		ghost_text = {
			enabled = false
		}
	},
	cmdline = {
		enabled = false
	},
	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer" },
		per_filetype = {
			org = { 'orgmode', 'buffer' }
		},
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
			orgmode = {
				name = 'Orgmode',
				module = 'orgmode.org.autocompletion.blink',
				fallbacks = { 'buffer' },
			},
			ripgrep = {
				module = "blink-ripgrep",
				name = "Ripgrep",
				-- see the full configuration below for all available options
				---@module "blink-ripgrep"
				---@type blink-ripgrep.Options
				opts = {},
			},
		}
	},
}

--- @type LazyPluginSpec
return {
	"Saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"mikavilpas/blink-ripgrep.nvim",
	},
	version = "*",
	opts = opts,
}
