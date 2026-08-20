---@module 'lazy'
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
			org = { 'buffer' }
		},
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		}
	},
}

--- @type LazyPluginSpec[]
local dependencies = {
	{ "rafamadriz/friendly-snippets" },
}

--- @type LazyPluginSpec
return {
	"Saghen/blink.cmp",
	dependencies = dependencies,
	version = "*",
	opts = opts,
}
