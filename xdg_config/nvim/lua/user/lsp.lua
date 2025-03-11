-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, bufnr)
	if client.name == "tsserver" or client.name == "omnisharp" then
		client.server_capabilities.document_formatting = false
		client.server_capabilities.documentFormattingProvider = false
	end
end

local function setup()
	require("neodev").setup({})

	local lspconfig = require("lspconfig")
	local util = lspconfig.util


	lspconfig.util.default_config = vim.tbl_extend(
		"force",
		lspconfig.util.default_config,
		{
			autostart = true,
			on_attach = on_attach,
			-- See link below for more default configurations
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
			capabilities = {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true
					},
					completion = {
						completionItem = {
							snippetSupport = true
						}
					}
				}
			}
		}
	)

	vim.diagnostic.config({ virtual_text = false })

	require("user.lsp.completion_icons").setup()
	require("user.lsp.floating_window_decoration").setup()

	-- Servers config
	lspconfig.denols.setup({
		root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
	})

	lspconfig.rust_analyzer.setup({
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	})

	lspconfig.pest_ls.setup({})

	lspconfig.racket_langserver.setup({
		cmd = { "racket", "--lib", "racket-langserver" },
		filetypes = { "racket", "scheme" },
		single_file_support = true,
	})

	lspconfig.svelte.setup({})

	lspconfig.pyright.setup({})

	lspconfig.jsonls.setup({
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
	})

	lspconfig.yamlls.setup({
		settings = {
			yaml = {
				keyOrdering = false,
			},
		},
	})

	lspconfig.gopls.setup({})

	lspconfig.teal_ls.setup({})

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

	lspconfig.hls.setup(
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
		})

	lspconfig.standardrb.setup({})

	lspconfig.clangd.setup({})

	lspconfig.marksman.setup({})

	-- lspconfig.elixirls.setup({})
	-- config.nextls.setup({})
	lspconfig.lexical.setup({})

	lspconfig.gdscript.setup({})

	lspconfig.omnisharp.setup({})

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

	lspconfig.gleam.setup({})

	lspconfig.bashls.setup({})

	lspconfig.emmet_ls.setup({
		filetypes = { "html", "heex", "typescriptreact", "svelte" },
	})

	lspconfig.nil_ls.setup({
		settings = {
			["nil"] = {
				formatting = {
					command = {
						"nixpkgs-fmt"
					}
				}
			}
		}
	})

	lspconfig.efm.setup({})
end

return {
	setup = setup,
}
