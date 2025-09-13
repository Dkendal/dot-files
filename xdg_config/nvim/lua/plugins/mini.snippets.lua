--- @module 'lazy'
--- @type LazyPluginSpec
return {
		"echasnovski/mini.snippets",
		version = false,
		init = function()
			local gen_loader = require("mini.snippets").gen_loader
			require("mini.snippets").setup({
				snippets = {
					-- Load custom file with global snippets first (adjust for Windows)
					gen_loader.from_file(vim.fs.joinpath(vim.fn.stdpath("config"), "/snippets/global.lua")),
					-- Load snippets based on current language by reading files from
					-- "snippets/" subdirectories from 'runtimepath' directories.
					gen_loader.from_lang(),
				},
			})
		end,
		keys = {
			{
				"<C-c>",
				function()
					while MiniSnippets.session.get() do
						MiniSnippets.session.stop()
					end
				end,
				mode = "n",
			},
		},
	}
