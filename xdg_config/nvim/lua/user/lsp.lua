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

	local lspconfig = require("lspconfig")
	local util = lspconfig.util

	vim.diagnostic.config({ virtual_text = false })

	require("user.lsp.completion_icons").setup()
	require("user.lsp.floating_window_decoration").setup()

	-- Servers config
	lspconfig.denols.setup(with_defaults({
		root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
	}))

	-- lspconfig.ts_ls.setup(with_defaults({
	-- 	filetypes = {
	-- 		"javascript",
	-- 		"javascriptreact",
	-- 		"javascript.jsx",
	-- 		"typescript",
	-- 		"typescriptreact",
	-- 		"typescript.tsx",
	-- 	},
	-- 	root_dir = lspconfig.util.root_pattern("package.json"),
	-- 	on_attach = function(client, bufnr)
	-- 		local is_deno = util.root_pattern('deno.json', 'import_map.json', 'deno.jsonc')(vim.fn.getcwd())
	--
	-- 		if is_deno then
	-- 			client.stop()
	-- 			return
	-- 		end
	--
	-- 		client.server_capabilities.document_formatting = false
	-- 		client.server_capabilities.documentFormattingProvider = false
	-- 	end,
	-- 	settings = {
	-- 		codeActionsOnSave = {
	-- 			source = { organizeImports = true }
	-- 		},
	-- 	}
	-- }))

	lspconfig.rust_analyzer.setup(with_defaults({
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	}))

	lspconfig.pest_ls.setup(with_defaults({}))

	lspconfig.racket_langserver.setup({
		cmd = { "racket", "--lib", "racket-langserver" },
		filetypes = { "racket", "scheme" },
		single_file_support = true,
	})

	lspconfig.svelte.setup(with_defaults({}))

	lspconfig.pyright.setup(with_defaults({}))

	lspconfig.jsonls.setup(with_defaults({
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

	lspconfig.yamlls.setup(with_defaults({
		settings = {
			yaml = {
				keyOrdering = false,
			},
		},
	}))

	lspconfig.gopls.setup(with_defaults({}))

	lspconfig.teal_ls.setup(with_defaults({}))

	local lua_runtime_path = vim.split(package.path, ";")
	table.insert(lua_runtime_path, "lua/?.lua")
	table.insert(lua_runtime_path, "lua/?/init.lua")

	lspconfig.lua_ls.setup({
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

	lspconfig.fennel_ls.setup({})

	lspconfig.taplo.setup({})

	lspconfig.terraformls.setup({})

	lspconfig.hls.setup(with_defaults(
		{
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

	lspconfig.standardrb.setup(with_defaults({}))

	lspconfig.clangd.setup(with_defaults({}))

	lspconfig.marksman.setup(with_defaults({}))

	lspconfig.elixirls.setup(with_defaults({}))
	-- config.nextls.setup(with_defaults({}))
	-- config.lexical.setup(with_defaults({}))

	lspconfig.gdscript.setup(with_defaults({}))

	lspconfig.omnisharp.setup(with_defaults({}))

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

	lspconfig.gleam.setup(with_defaults({}))

	lspconfig.bashls.setup(with_defaults({}))

	lspconfig.emmet_ls.setup(with_defaults({
		filetypes = { "html", "heex", "typescriptreact", "svelte" },
	}))

	lspconfig.nil_ls.setup(with_defaults({
		settings = {
			["nil"] = {
				formatting = {
					command = {
						"nixpkgs-fmt"
					}
				}
			}
		}
	}))

	lspconfig.rnix.setup(with_defaults({}))

	lspconfig.efm.setup(with_defaults({}))
end

return {
	setup = setup,
}
