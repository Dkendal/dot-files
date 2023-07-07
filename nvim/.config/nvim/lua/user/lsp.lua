require("neodev").setup({})

local lspconfig = require("lspconfig")
local lsp_status = require("lsp-status")

vim.diagnostic.config({ virtual_text = false })

require("user.lsp.completion_icons").setup()
require("user.lsp.floating_window_decoration").setup()

local function assign(...)
	return vim.tbl_extend("force", ...)
end

local function mk_capabilities()
	local t = lsp_status.capabilities

	t = vim.tbl_deep_extend("force", t, require("cmp_nvim_lsp").default_capabilities())

	t.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	t.textDocument.completion.completionItem.snippetSupport = true

	return t
end

vim.lsp.set_log_level(2)

lsp_status.config({
	indicator_errors = "",
	indicator_warnings = "",
	indicator_info = "?",
	indicator_hint = "!",
	indicator_ok = "✔",
	status_symbol = "λ ",
})

lsp_status.register_progress()

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, opts)
	lsp_status.on_attach(client)

	if client.name == "tsserver" then
		client.server_capabilities.document_formatting = false      -- 0.7 and earlier
		client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
	end
end

-- See link below for more default configurations
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

local capabilities = mk_capabilities()

local opts = {
	autostart = true,
	on_attach = on_attach,
	capabilities = capabilities,
}

lspconfig.denols.setup(assign(opts, {
	root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
}))

lspconfig.tsserver.setup(assign(opts, {
	verbose = true,
	root_dir = lspconfig.util.root_pattern("package.json"),
	settings = {
		typescript = {
			inlayHints = {
				enumMemberValues = true,
				functionLikeReturnTypes = true,
				parameterNames = true,
				parameterTypes = true,
				propertyDeclarationTypes = true,
				variableTypes = true,
			},
			preferences = {
				importModuleSpecifierPreference = "relative",
				provideRefactorNotApplicableReason = true,
			},
		},
	},
	commands = {
		RenameFile = {
			function()
				local old_name = vim.api.nvim_buf_get_name(0)

				vim.ui.input({
					prompt = "New name: ",
					default = old_name,
				}, function(name)
					if name then
						vim.lsp.buf.execute_command({
							command = "_typescript.applyRenameFile",
							arguments = { { sourceUri = old_name, targetUri = name } },
							title = "",
						})
					end
				end)
			end,
			description = "Organize Imports",
		},
		OrganizeImports = {
			function()
				vim.lsp.buf.execute_command({
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = "",
				})
			end,
			description = "Organize Imports",
		},
	},
	flags = { debounce_text_changes = 500 },
}))

lspconfig.rust_analyzer.setup(assign(opts, {}))

lspconfig.racket_langserver.setup({
	cmd = { "racket", "--lib", "racket-langserver" },
	filetypes = { "racket", "scheme" },
	single_file_support = true,
})

lspconfig.svelte.setup(assign(opts, {}))

lspconfig.pyright.setup(assign(opts, {
	cmd = {
		"/home/dylan/.asdf/installs/nodejs/16.4.2/bin/node",
		"/home/dylan/.asdf/installs/nodejs/16.4.2/.npm/bin/pyright-langserver",
		"--stdio",
	},
}))

lspconfig.jsonls.setup(assign(opts, {
	settings = {
		json = {
			schemas = {
				{
					fileMatch = { ".swcrc" },
					url = "https://json.schemastore.org/swcrc.json",
				},
				{
					fileMatch = { ".prettierrc" },
					url = { "https://json.schemastore.org/prettierrc" },
				},
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
				{
					fileMatch = {
						".github/workflows/actions/action.yaml",
						".github/workflows/actions/action.yml",
					},
					url = "https://json.schemastore.org/github-action.json",
				},
			},
		},
	},
}))

lspconfig.yamlls.setup(assign(opts, {
	settings = {
		yaml = {
			keyOrdering = false,
		},
	},
}))

lspconfig.gopls.setup(assign(opts, {}))

lspconfig.teal_ls.setup(assign(opts, {}))

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.lua_ls.setup({
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
			telemetry = {
				enable = false,
			},
		},
	},
})

lspconfig.taplo.setup({})

lspconfig.terraformls.setup({})

lspconfig.hls.setup(assign(opts, {
	settings = {
		haskell = {
			checkParents = "CheckOnSave",
			checkProject = true,
			maxCompletions = 40,
			formattingProvider = "fourmolu",
			plugin = {
				rename = {
					globalOn = true,
					config = {
						crossModule = false,
					},
				},
				["ghcide-completions"] = {
					globalOn = true,
					config = {
						autoExtendOn = true,
						snippetsOn = true,
					},
				},
				class = {
					globalOn = true,
				},
				refineImports = {
					codeActionsOn = true,
					codeLensOn = true,
				},
				splice = {
					globalOn = true,
				},
				pragmas = {
					completionOn = true,
					codeActionsOn = true,
				},
				changeTypeSignature = {
					globalOn = true,
				},
				qualifyImportedNames = {
					globalOn = true,
				},
				alternateNumberFormat = {
					globalOn = true,
				},
				hlint = {
					codeActionsOn = true,
					diagnosticsOn = true,
					config = {
						flags = {},
					},
				},
				["ghcide-code-actions-fill-holes"] = {
					globalOn = true,
				},
				haddockComments = {
					globalOn = true,
				},
				importLens = {
					codeActionsOn = true,
					codeLensOn = true,
				},
				retrie = {
					globalOn = true,
				},
				["ghcide-type-lenses"] = {
					globalOn = true,
					config = {
						mode = "always",
					},
				},
				["ghcide-code-actions-imports-exports"] = {
					globalOn = true,
				},
				["ghcide-hover-and-symbols"] = {
					symbolsOn = true,
					hoverOn = true,
				},
				eval = {
					globalOn = true,
					config = {
						diff = true,
						exception = false,
					},
				},
				tactics = {
					codeActionsOn = true,
					codeLensOn = true,
					hoverOn = true,
					config = {
						auto_gas = 4,
						max_use_ctor_actions = 5,
						proofstate_styling = true,
						timeout_duration = 2,
						hole_severity = nil,
					},
				},
				callHierarchy = {
					globalOn = true,
				},
				["ghcide-code-actions-type-signatures"] = {
					globalOn = true,
				},
				["ghcide-code-actions-bindings"] = {
					globalOn = true,
				},
				moduleName = {
					globalOn = true,
				},
			},
		},
	},
}))

-- Ruby
lspconfig.ruby_ls.setup(assign(opts, {}))

lspconfig.sorbet.setup(assign(opts, {}))

lspconfig.standardrb.setup(assign(opts, {}))

lspconfig.clangd.setup(assign(opts, {}))

-- Markdown
lspconfig.marksman.setup(assign(opts, {}))

-- Elixir
lspconfig.elixirls.setup(assign(opts, {
	cmd = { "elixir-ls" },
}))

-- HTML

lspconfig.tailwindcss.setup({
	init_options = {
		userLanguages = {
			elixir = "phoenix-heex",
			eruby = "erb",
			heex = "phoenix-heex",
			svelte = "html",
		},
	},
	settings = {
		includeLanguages = {
			typescript = "javascript",
			typescriptreact = "javascript",
			["html-eex"] = "html",
			["phoenix-heex"] = "html",
			heex = "html",
			eelixir = "html",
			elm = "html",
			erb = "html",
			svelte = "html",
		},
		tailwindCSS = {
			experimental = {
				classRegex = {
					[[class= "([^"]*)]],
					[[class: "([^"]*)]],
					'~H""".*class="([^"]*)".*"""',
				},
			},
		},
	},
})

lspconfig.emmet_ls.setup(assign(opts, {
	filetypes = { "html", "heex", "typescriptreact" },
}))

-- Nix
lspconfig.nil_ls.setup(assign(opts, {}))

lspconfig.rnix.setup(assign(opts, {}))

-- Null-LS
local null_ls = require("null-ls")

local h = require("null-ls.helpers")

local dprint = {
	name = "dprint",
	method = null_ls.methods.FORMATTING,
	filetypes = {
		"json",
		"markdown",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"toml",
		"dockerfile",
		"html",
		"css",
	},
	generator = h.formatter_factory({
		command = "dprint",
		args = {
			"fmt",
			"--stdin",
			"$FILENAME",
		},
		to_stdin = true,
	}),
}

local pg_format = {
	name = "pg_format",
	method = null_ls.methods.FORMATTING,
	filetypes = { "sql" },
	generator = h.formatter_factory({
		command = "pg_format",
		args = {
			"--key-newline",
			"--comma-start",
			"--comma-break",
			"--keyword-case=1",
			"--keyword-case=1",
			"--type-case=1",
			"--function-case=1",
			"--wrap-after=120",
		},
		to_stdin = true,
	}),
}

local sqlfmt = {
	name = "sqlfmt",
	method = null_ls.methods.FORMATTING,
	filetypes = { "sql" },
	generator = h.formatter_factory({
		command = "sqlfmt",
		args = {
			"--no-simplify",
			"--casemode=lower",
		},
		to_stdin = true,
	}),
}

null_ls.setup({
	root_dir = require("null-ls.utils").root_pattern(".git", "package.json"),
	debug = true,
	sources = {
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.fish,
		-- null_ls.builtins.diagnostics.sqlfluff.with({ extra_args = { "--dialect", "postgres" } }),
		-- pg_format,
		sqlfmt,
		require("nvim-kitty").diagnostics,
		null_ls.builtins.diagnostics.luacheck.with({ extra_args = { "--globals", "vim" } }),
		null_ls.builtins.formatting.shellharden,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.mix,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.fixjson,
		null_ls.builtins.formatting.prettier.with({
			only_local = "node_modules/.bin",
		}),
	},
})
