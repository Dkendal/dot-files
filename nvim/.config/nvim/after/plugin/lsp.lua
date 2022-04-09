local lspconfig = require("lspconfig")
local ts = require("telescope.builtin")
local cmp = require("cmp")

require("user.lsp.completion_icons").setup()
require("user.lsp.floating_window_decoration").setup()

local function assign(...)
	return vim.tbl_extend("force", ...)
end

vim.lsp.set_log_level(3)

local lsp_status = require("lsp-status")

lsp_status.register_progress()

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, _)
	local map = vim.keymap.set

	lsp_status.on_attach(client)
	print("attach")

	-- Mappings.
	local opts = { silent = true, noremap = true, buffer = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	map("i", "<C-h>", vim.lsp.buf.signature_help, opts)
	map("n", "<space>D", vim.lsp.buf.type_definition, opts)
	map("n", "<space>F", vim.lsp.buf.formatting, opts)
	map("n", "<space>Wa", vim.lsp.buf.add_workspace_folder, opts)
	map("n", "<space>Wr", vim.lsp.buf.remove_workspace_folder, opts)
	map("n", "<space>ee", vim.lsp.diagnostic.show_line_diagnostics, opts)
	map("n", "<space>rn", vim.lsp.buf.rename, opts)
	map("n", "K", vim.lsp.buf.hover, opts)
	map("n", "[d", vim.lsp.diagnostic.goto_prev, opts)
	map("n", "]d", vim.lsp.diagnostic.goto_next, opts)
	map("n", "gD", vim.lsp.buf.declaration, opts)
	map("n", "gO", vim.lsp.buf.document_symbol, opts)
	map("n", "gd", vim.lsp.buf.definition, opts)
	map("n", "gi", vim.lsp.buf.implementation, opts)

	map("n", "<space>ca", vim.lsp.buf.code_action, opts)

	map("v", "<space>ca", vim.lsp.buf.range_code_action, opts)

	map("n", "<space>Wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)

	map("n", "gr", "<cmd>TroubleToggle lsp_references<CR>", opts)
end

-- See link below for more default configurations
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

local capabilities = lsp_status.capabilities

capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

capabilities.textDocument.completion.completionItem.snippetSupport = true

local opts = {
	autostart = true,
	on_attach = on_attach,
	capabilities = capabilities,
}

lspconfig.tsserver.setup(assign(opts, {
	verbose = true,
	settings = {
		typescript = {
			preferences = {
				importModuleSpecifierPreference = "relative",
				provideRefactorNotApplicableReason = true,
			},
		},
	},
	flags = { debounce_text_changes = 500 },
}))

lspconfig.racket_langserver.setup({
	cmd = { "racket", "--lib", "racket-langserver" },
	filetypes = { "racket", "scheme" },
	single_file_support = true,
})

lspconfig.pyright.setup(assign(opts, {
	cmd = {
		"/home/dylan/.asdf/installs/nodejs/16.4.2/bin/node",
		"/home/dylan/.asdf/installs/nodejs/16.4.2/.npm/bin/pyright-langserver",
		"--stdio",
	},
}))

lspconfig.jsonls.setup(assign(opts, {
	cmd = {
		"/home/dylan/.asdf/installs/nodejs/16.4.2/bin/node",
		"/home/dylan/.asdf/installs/nodejs/16.4.2/.npm/bin/vscode-json-language-server",
		"--stdio",
	},
	settings = {
		json = {
			schemas = {
				{
					fileMatch = { ".luarc.json" },
					url = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json",
				},
				{
					fileMatch = { "firebase.json" },
					url = "https://raw.githubusercontent.com/firebase/firebase-tools/master/schema/firebase-config.json",
				},
				{
					fileMatch = { "package.json" },
					url = "https://json.schemastore.org/package.json",
				},
				{
					fileMatch = { "tsconfig.json", "tsconfig*.json" },
					url = "https://json.schemastore.org/tsconfig",
				},
				{
					fileMatch = { "Taskfile.yaml" },
					url = "https://json.schemastore.org/taskfile.json",
				},
				{
					fileMatch = { ".github/workflows/*.yaml", ".github/workflows/*.yml" },
					url = "https://json.schemastore.org/github-workflow.json",
				},
			},
		},
	},
}))

lspconfig.yamlls.setup(assign(opts, {}))

lspconfig.gopls.setup(assign(opts, {}))

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

lspconfig.clangd.setup(assign(opts, {}))

lspconfig.elixirls.setup(assign(opts, {
	cmd = { "/home/dylan/.elixir-ls/release/language_server.sh" },
}))

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.completion.spell,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.shellharden,
		null_ls.builtins.formatting.prettier.with({
			prefer_local = "node_modules/.bin",
		}),
	},
})
