local function picker()
	return require("snacks").picker
end

---@module "lazy"
---@type LazyKeysSpec[]
local keys = {
	-- Scratch
	{ "<leader>.",       function() Snacks.scratch() end,                                   desc = "Toggle Scratch Buffer", },
	{ "<leader>S",       function() Snacks.scratch.select() end,                            desc = "Select Scratch Buffer", },
	-- Spell check
	{ "s=",              function() picker().spelling() end,                                desc = "Correct spelling", },
	-- Top Pickers & Explorer
	{ "<leader><space>", function() picker().smart() end,                                   desc = "Smart Find Files", },
	{ "<leader>,",       function() picker().buffers() end,                                 desc = "Buffers", },
	{ "<leader>/",       function() picker().grep() end,                                    desc = "Grep", },
	{ "<leader>:",       function() picker().command_history() end,                         desc = "Command History", },
	{ "<leader>n",       function() picker().notifications() end,                           desc = "Notification History", },
	{ "<leader>e",       function() Snacks.explorer() end,                                  desc = "File Explorer", },
	-- find
	{ "<leader>fb",      function() picker().buffers() end,                                 desc = "Buffers", },
	{ "<leader>fc",      function() picker().files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File", },
	{ "<leader>fd",      function() picker().files({ cwd = vim.fn.stdpath("data") }) end,   desc = "Find Data File", },
	{ "<leader>ff",      function() picker().files({ hidden = true }) end,                  desc = "Find Files", },
	{ "<leader>fo",      function() picker().files({ cwd = "~/orgfiles" }) end,             desc = "Find Org Files", },
	{ "<leader>so",      require("user.orgmode.snacks").picker_orgmode_grep,                desc = "Search Org files", },
	{ "<leader>sO",      require("user.orgmode.snacks").picker_orgmode_headlines,           desc = "Search Org Headlines", },
	{ "<leader>fg",      function() picker().git_files() end,                               desc = "Find Git Files", },
	{ "<leader>fp",      function() picker().projects() end,                                desc = "Projects", },
	{ "<leader>fr",      function() picker().recent() end,                                  desc = "Recent", },
	-- git
	{ "<leader>gb",      function() picker().git_branches() end,                            desc = "Git Branches", },
	{ "<leader>gl",      function() picker().git_log() end,                                 desc = "Git Log", },
	{ "<leader>gL",      function() picker().git_log_line() end,                            desc = "Git Log Line", },
	{ "<leader>gs",      function() picker().git_status() end,                              desc = "Git Status", },
	{ "<leader>gS",      function() picker().git_stash() end,                               desc = "Git Stash", },
	{ "<leader>gd",      function() picker().git_diff() end,                                desc = "Git Diff (Hunks)", },
	{ "<leader>gf",      function() picker().git_log_file() end,                            desc = "Git Log File", },
	-- Grep
	{ "<leader>sb",      function() picker().lines() end,                                   desc = "Buffer Lines", },
	{ "<leader>sB",      function() picker().grep_buffers() end,                            desc = "Grep Open Buffers", },
	{ "<leader>sg",      function() picker().grep() end,                                    desc = "Grep", },
	{ "<leader>sw",      function() picker().grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" }, },
	-- search
	{ '<leader>s"',      function() picker().registers() end,                               desc = "Registers", },
	{ "<leader>s/",      function() picker().search_history() end,                          desc = "Search History", },
	{ "<leader>sa",      function() picker().autocmds() end,                                desc = "Autocmds", },
	{ "<leader>sb",      function() picker().lines() end,                                   desc = "Buffer Lines", },
	{ "<leader>sc",      function() picker().command_history() end,                         desc = "Command History", },
	{ "<leader>sC",      function() picker().commands() end,                                desc = "Commands", },
	{ "<leader>sd",      function() picker().diagnostics() end,                             desc = "Diagnostics", },
	{ "<leader>sD",      function() picker().diagnostics_buffer() end,                      desc = "Buffer Diagnostics", },
	{ "<leader>sh",      function() picker().help() end,                                    desc = "Help Pages", },
	{ "<leader>sH",      function() picker().highlights() end,                              desc = "Highlights", },
	{ "<leader>si",      function() picker().icons() end,                                   desc = "Icons", },
	{ "<leader>sj",      function() picker().jumps() end,                                   desc = "Jumps", },
	{ "<leader>sk",      function() picker().keymaps() end,                                 desc = "Keymaps", },
	{ "<leader>sl",      function() picker().loclist() end,                                 desc = "Location List", },
	{ "<leader>sm",      function() picker().marks() end,                                   desc = "Marks", },
	{ "<leader>sM",      function() picker().man() end,                                     desc = "Man Pages", },
	{ "<leader>sP",      function() picker().lazy() end,                                    desc = "Search for Plugin Spec", },
	{ "<leader>sq",      function() picker().qflist() end,                                  desc = "Quickfix List", },
	{ "<leader>sR",      function() picker().resume() end,                                  desc = "Resume", },
	{ "<leader>su",      function() picker().undo() end,                                    desc = "Undo History", },
	{ "<leader>hdC",     function() picker().colorschemes() end,                            desc = "Colorschemes", },
	-- LSP
	{ "gd",              function() picker().lsp_definitions() end,                         desc = "Goto Definition", },
	{ "gD",              function() picker().lsp_declarations() end,                        desc = "Goto Declaration", },
	{ "gr",              function() picker().lsp_references() end,                          nowait = true,                     desc = "References", },
	{ "gI",              function() picker().lsp_implementations() end,                     desc = "Goto Implementation", },
	{ "gy",              function() picker().lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition", },
	{ "<leader>ss",      function() picker().lsp_symbols() end,                             desc = "LSP Symbols", },
	{ "<leader>sS",      function() picker().lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols", },
}

---@type LazyPluginSpec
return {
	"folke/snacks.nvim",
	lazy = false,
	---@module "snacks.meta.types"
	---@type snacks.Config
	opts = {
		indent = {},
		picker = {
			matcher = {
				cwd_bonus = true,
				frecency = true,
			},
		},
		bigfile = {},
		quickfile = {},
		scroll = {},
		statuscolumn = {},
		gitbrowse = {},
		image = {},
	},
	keys = keys,
}
