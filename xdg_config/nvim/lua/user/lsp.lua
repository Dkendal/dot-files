-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, bufnr)
	if client.name == "tsserver" or client.name == "omnisharp" then
		client.server_capabilities.document_formatting = false
		client.server_capabilities.documentFormattingProvider = false
	end
end

local function with_defaults(tbl)
	-- See link below for more default configurations
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	local lsp_status = require("lsp-status")
	local capabilities = lsp_status.capabilities
	local defaults = require("cmp_nvim_lsp").default_capabilities()

	capabilities = vim.tbl_deep_extend("force", capabilities, defaults)

	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	capabilities.textDocument.completion.completionItem.snippetSupport = true

	local lsp_default_opts = {
		autostart = true,
		on_attach = on_attach,
		capabilities = capabilities,
	}

	return vim.tbl_extend("force", lsp_default_opts, tbl)
end

local function setup()
	require("neodev").setup({})

	local config = require("lspconfig")

	vim.diagnostic.config({ virtual_text = false })

	require("user.lsp.completion_icons").setup()
	require("user.lsp.floating_window_decoration").setup()

	-- Servers config
	config.denols.setup(with_defaults({
		root_dir = config.util.root_pattern("deno.json", "deno.jsonc"),
	}))

	config.tsserver.setup(with_defaults({
		verbose = true,
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		root_dir = config.util.root_pattern("package.json"),
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

	config.rust_analyzer.setup(with_defaults({
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	}))

	config.pest_ls.setup(with_defaults({}))

	config.racket_langserver.setup({
		cmd = { "racket", "--lib", "racket-langserver" },
		filetypes = { "racket", "scheme" },
		single_file_support = true,
	})

	config.svelte.setup(with_defaults({}))

	config.pyright.setup(with_defaults({}))

	config.jsonls.setup(with_defaults({
		settings = {
			json = {
				schemas = {
					{
						fileMatch = { "manifest.json" },
						url = "https://json.schemastore.org/chrome-manifest.json",
					},
					{
						fileMatch = { "omnisharp.json" },
						url = "https://json.schemastore.org/omnisharp.json",
					},
					{
						fileMatch = { ".swcrc" },
						url = { "https://swc.rs/schema.json" },
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
						fileMatch = { "rules/*.yml", "rule-tests/*.yml", "utils/*.yml" },
						url = "https://raw.githubusercontent.com/ast-grep/ast-grep/main/schemas/rule.json",
					},
					{
						fileMatch = { "Taskfile.yaml" },
						url = "https://json.schemastore.org/taskfile.json",
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

	config.yamlls.setup(with_defaults({
		settings = {
			yaml = {
				keyOrdering = false,
			},
		},
	}))

	config.gopls.setup(with_defaults({}))

	config.teal_ls.setup(with_defaults({}))

	local lua_runtime_path = vim.split(package.path, ";")
	table.insert(lua_runtime_path, "lua/?.lua")
	table.insert(lua_runtime_path, "lua/?/init.lua")

	config.lua_ls.setup({
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Setup your lua path
					path = lua_runtime_path,
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = {
						vim.api.nvim_get_runtime_file("", true),
						"/Users/dylan/src/dkendal/luassert/library/",
					},
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})

	config.taplo.setup({})

	config.terraformls.setup({})

	config.hls.setup(with_defaults({
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

	config.standardrb.setup(with_defaults({}))

	config.clangd.setup(with_defaults({}))

	config.marksman.setup(with_defaults({}))

	config.elixirls.setup(with_defaults({
		cmd = { "elixir-ls" },
	}))

	config.gdscript.setup(with_defaults({}))

	config.omnisharp.setup(with_defaults({}))

	config.tailwindcss.setup({
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

	config.gleam.setup(with_defaults({}))

	config.bashls.setup(with_defaults({}))

	config.emmet_ls.setup(with_defaults({
		filetypes = { "html", "heex", "elixir", "typescriptreact", "svelte" },
	}))

	config.nil_ls.setup(with_defaults({}))

	config.rnix.setup(with_defaults({}))

	config.typst_lsp.setup(with_defaults({}))

	-- config.biome.setup(with_defaults({}))

	config.ast_grep.setup(with_defaults({}))
end

return {
	setup = setup,
}
