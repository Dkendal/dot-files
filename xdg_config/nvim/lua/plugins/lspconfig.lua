---@module 'lazy'
local enabled_langservers = {
	"bashls",
	"biome",
	"clangd",
	"efm",
	"emmet_ls",
	"fennel_ls",
	"gdscript",
	"gleam",
	"gopls",
	"jsonls",
	"lua_ls",
	"marksman",
	"pest_ls",
	"pyright",
	"racket_langserver",
	"rust_analyzer",
	"svelte",
	"taplo",
	"teal_ls",
	"terraformls",
	"nil_ls",
	-- "ts_ls",
	"biome",
	-- "expert",
	"lexical",
	"typescript_go_ls"
}

---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"lvimuser/lsp-inlayhints.nvim",
		{ "ray-x/lsp_signature.nvim", opts = {} },
		{
			"seblyng/roslyn.nvim",
			---@module 'roslyn.config'
			---@type RoslynNvimConfig
			opts = {
				-- your configuration comes here; leave empty for default settings
			},
		}
	},
	init = function()
		-- :help lspconfig-all
		local lspconfig = require("lspconfig")

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		-- Use an on_attach function to only map the following keys
		-- after the language server attaches to the current buffer
		local function on_attach(client, _bufnr)
		end

		vim.diagnostic.config({ virtual_text = false })

		local lsp_config =
				vim.tbl_deep_extend("force",
					lspconfig.util.default_config,
					{
						capabilities = require("blink.cmp").get_lsp_capabilities(),
						on_attach = on_attach,
					}
				)

		vim.lsp.config("*", lsp_config)

		for _, name in ipairs(enabled_langservers) do
			vim.lsp.enable(name, true)
		end

		local icons = {
			Class = "",
			Color = "",
			Constant = "",
			Constructor = "",
			Enum = "",
			EnumMember = "",
			Field = "",
			File = "",
			Folder = "",
			Function = "󰊕",
			Interface = "",
			Keyword = "",
			Method = "",
			Module = "󰕳",
			Property = "",
			Snippet = "",
			Struct = "",
			Text = "󰦨",
			Unit = "1",
			Value = "v",
			Variable = "󰫧",
		}

		local kinds = vim.lsp.protocol.CompletionItemKind

		for i, kind in ipairs(kinds) do
			kinds[i] = icons[kind] or kind
		end

		local border = {
			{ "🭽", "FloatBorder" },
			{ "▔", "FloatBorder" },
			{ "🭾", "FloatBorder" },
			{ "▕", "FloatBorder" },
			{ "🭿", "FloatBorder" },
			{ "▁", "FloatBorder" },
			{ "🭼", "FloatBorder" },
			{ "▏", "FloatBorder" },
		}

		-- To instead override globally
		local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

		local fn = function(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or border
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end

		vim.lsp.util.open_floating_preview = fn;
	end,
}
