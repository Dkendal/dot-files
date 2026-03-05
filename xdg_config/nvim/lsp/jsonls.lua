return {
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
				{
					fileMatch = {
						".claude/settings.json",
						".claude/settings.local.json",
						"~/.claude/settings.json",
					},
					url = "https://json.schemastore.org/claude-code-settings.json",
				},
			},
		},
	},
}
