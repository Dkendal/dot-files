return {
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
}
