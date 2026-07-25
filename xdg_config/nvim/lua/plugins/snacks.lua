local function picker()
	return require("snacks").picker
end

---@module "lazy"
---@type LazyKeysSpec[]
local keys = {
	-- Scratch
	{
		"<leader>.",
		function()
			Snacks.scratch()
		end,
		desc = "Toggle Scratch Buffer",
	},
	{
		"<leader>S",
		function()
			Snacks.scratch.select()
		end,
		desc = "Select Scratch Buffer",
	},
	-- Spell check
	{
		"s=",
		function()
			picker().spelling()
		end,
		desc = "Correct spelling",
	},
	-- Top Pickers & Explorer
	{
		"<leader><space>",
		function()
			picker().smart()
		end,
		desc = "Smart Find Files",
	},
	{
		"<leader>,",
		function()
			picker().buffers()
		end,
		desc = "Buffers",
	},
	{
		"<leader>/",
		function()
			picker().grep()
		end,
		desc = "Grep",
	},
	{
		"<leader>:",
		function()
			picker().command_history()
		end,
		desc = "Command History",
	},
	{
		"<leader>n",
		function()
			picker().notifications()
		end,
		desc = "Notification History",
	},
	{
		"<leader>e",
		function()
			Snacks.explorer()
		end,
		desc = "File Explorer",
	},
	-- find
	{
		"<leader>fb",
		function()
			picker().buffers()
		end,
		desc = "Buffers",
	},
	{
		"<leader>fc",
		function()
			picker().files({ cwd = vim.fn.stdpath("config") })
		end,
		desc = "Find Config File",
	},
	{
		"<leader>fd",
		function()
			picker().files({ cwd = vim.fn.stdpath("data") })
		end,
		desc = "Find Data File",
	},
	{
		"<leader>ff",
		function()
			picker().files({ hidden = true })
		end,
		desc = "Find Files",
	},
	{
		"<leader>fo",
		function()
			picker().files({ cwd = "~/orgfiles" })
		end,
		desc = "Find Org Files",
	},
	{
		"<leader>so",
		require("ext.orgmode.snacks").picker_orgmode_grep,
		desc = "Search Org files",
	},
	{
		"<leader>sO",
		require("ext.orgmode.snacks").picker_orgmode_headlines,
		desc = "Search Org Headlines",
	},
	{
		"<leader>fg",
		function()
			picker().git_files()
		end,
		desc = "Find Git Files",
	},
	{
		"<leader>fp",
		function()
			picker().projects()
		end,
		desc = "Projects",
	},
	{
		"<leader>fr",
		function()
			picker().recent()
		end,
		desc = "Recent",
	},
	-- git
	{
		"<leader>gb",
		function()
			picker().git_branches()
		end,
		desc = "Git Branches",
	},
	{
		"<leader>gl",
		function()
			picker().git_log()
		end,
		desc = "Git Log",
	},
	{
		"<leader>gL",
		function()
			picker().git_log_line()
		end,
		desc = "Git Log Line",
	},
	{
		"<leader>gs",
		function()
			require("ext.snacks.picker.jj").vcs_status()
		end,
		desc = "VCS Status",
	},
	{
		"<leader>gS",
		function()
			picker().git_stash()
		end,
		desc = "Git Stash",
	},
	{
		"<leader>gd",
		function()
			picker().git_diff()
		end,
		desc = "Git Diff (Hunks)",
	},
	{
		"<leader>gf",
		function()
			picker().git_log_file()
		end,
		desc = "Git Log File",
	},
	-- Grep
	{
		"<leader>sb",
		function()
			picker().lines()
		end,
		desc = "Buffer Lines",
	},
	{
		"<leader>sB",
		function()
			picker().grep_buffers()
		end,
		desc = "Grep Open Buffers",
	},
	{
		"<leader>sg",
		function()
			picker().grep()
		end,
		desc = "Grep",
	},
	{
		"<leader>sw",
		function()
			picker().grep_word()
		end,
		desc = "Visual selection or word",
		mode = { "n", "x" },
	},
	-- search
	{
		'<leader>p',
		function()
			picker().registers({ confirm = {"paste", "close"} })
		end,
		desc = "Registers",
	},
	{
		"<leader>s/",
		function()
			picker().search_history()
		end,
		desc = "Search History",
	},
	{
		"<leader>sa",
		function()
			picker().autocmds()
		end,
		desc = "Autocmds",
	},
	{
		"<leader>sb",
		function()
			picker().lines()
		end,
		desc = "Buffer Lines",
	},
	{
		"<leader>sc",
		function()
			picker().command_history()
		end,
		desc = "Command History",
	},
	{
		"<leader>sC",
		function()
			picker().commands()
		end,
		desc = "Commands",
	},
	{
		"<leader>sd",
		function()
			picker().diagnostics()
		end,
		desc = "Diagnostics",
	},
	{
		"<leader>sD",
		function()
			picker().diagnostics_buffer()
		end,
		desc = "Buffer Diagnostics",
	},
	{
		"<leader>sh",
		function()
			picker().help()
		end,
		desc = "Help Pages",
	},
	{
		"<leader>sH",
		function()
			picker().highlights()
		end,
		desc = "Highlights",
	},
	{
		"<leader>si",
		function()
			picker().icons()
		end,
		desc = "Icons",
	},
	{
		"<leader>sj",
		function()
			picker().jumps()
		end,
		desc = "Jumps",
	},
	{
		"<leader>sk",
		function()
			picker().keymaps()
		end,
		desc = "Keymaps",
	},
	{
		"<leader>sl",
		function()
			picker().loclist()
		end,
		desc = "Location List",
	},
	{
		"<leader>sm",
		function()
			picker().marks()
		end,
		desc = "Marks",
	},
	{
		"<leader>sM",
		function()
			picker().man()
		end,
		desc = "Man Pages",
	},
	{
		"<leader>sP",
		function()
			picker().lazy()
		end,
		desc = "Search for Plugin Spec",
	},
	{
		"<leader>sq",
		function()
			picker().qflist()
		end,
		desc = "Quickfix List",
	},
	{
		"<leader>sR",
		function()
			picker().resume()
		end,
		desc = "Resume",
	},
	{
		"<leader>su",
		function()
			picker().undo()
		end,
		desc = "Undo History",
	},
	{
		"<leader>hdC",
		function()
			picker().colorschemes()
		end,
		desc = "Colorschemes",
	},
	-- LSP
	{
		"gd",
		function()
			picker().lsp_definitions()
		end,
		desc = "Goto Definition",
	},
	{
		"gD",
		function()
			picker().lsp_declarations()
		end,
		desc = "Goto Declaration",
	},
	{
		"gr",
		function()
			picker().lsp_references()
		end,
		nowait = true,
		desc = "References",
	},
	{
		"gI",
		function()
			picker().lsp_implementations()
		end,
		desc = "Goto Implementation",
	},
	{
		"gy",
		function()
			picker().lsp_type_definitions()
		end,
		desc = "Goto T[y]pe Definition",
	},
	{
		"<leader>ss",
		function()
			picker().lsp_symbols()
		end,
		desc = "LSP Symbols",
	},
	{
		"<leader>sS",
		function()
			picker().lsp_workspace_symbols()
		end,
		desc = "LSP Workspace Symbols",
	},
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
			win = {
				-- input window
				input = {
					keys = {
						-- to close the picker on ESC instead of going to normal mode,
						-- add the following keymap to your config
						-- ["<Esc>"] = { "close", mode = { "n", "i" } },
						["/"] = "toggle_focus",
						["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
						["<C-Up>"] = { "history_back", mode = { "i", "n" } },
						["<C-c>"] = { "cancel", mode = "i" },
						["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
						["<CR>"] = { "confirm", mode = { "n", "i" } },
						["<Down>"] = { "list_down", mode = { "i", "n" } },
						["<Esc>"] = "cancel",
						["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
						["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
						["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
						["<Up>"] = { "list_up", mode = { "i", "n" } },
						["<a-d>"] = { "inspect", mode = { "n", "i" } },
						["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
						["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
						["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
						["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
						["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
						["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
						-- ["<c-a>"] = { "select_all", mode = { "n", "i" } },
						["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
						["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
						["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
						["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
						["<c-j>"] = { "list_down", mode = { "i", "n" } },
						["<c-k>"] = { "list_up", mode = { "i", "n" } },
						["<c-n>"] = { "list_down", mode = { "i", "n" } },
						["<c-p>"] = { "list_up", mode = { "i", "n" } },
						["<c-q>"] = { "qflist", mode = { "i", "n" } },
						["<c-s>"] = { "edit_split", mode = { "i", "n" } },
						["<c-t>"] = { "tab", mode = { "n", "i" } },
						["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
						["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
						["<c-r>#"] = { "insert_alt", mode = "i" },
						["<c-r>%"] = { "insert_filename", mode = "i" },
						["<c-r><c-a>"] = { "insert_cWORD", mode = "i" },
						["<c-r><c-f>"] = { "insert_file", mode = "i" },
						["<c-r><c-l>"] = { "insert_line", mode = "i" },
						["<c-r><c-p>"] = { "insert_file_full", mode = "i" },
						["<c-r><c-w>"] = { "insert_cword", mode = "i" },
						["<c-w>H"] = "layout_left",
						["<c-w>J"] = "layout_bottom",
						["<c-w>K"] = "layout_top",
						["<c-w>L"] = "layout_right",
						["?"] = "toggle_help_input",
						["G"] = "list_bottom",
						["gg"] = "list_top",
						["j"] = "list_down",
						["k"] = "list_up",
						["q"] = "close",
					},
					b = {
						minipairs_disable = true,
					},
				},
				-- result list window
				list = {
					keys = {
						["/"] = "toggle_focus",
						["<2-LeftMouse>"] = "confirm",
						["<CR>"] = "confirm",
						["<Down>"] = "list_down",
						["<Esc>"] = "cancel",
						["<S-CR>"] = { { "pick_win", "jump" } },
						["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
						["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
						["<Up>"] = "list_up",
						["<a-d>"] = "inspect",
						["<a-f>"] = "toggle_follow",
						["<a-h>"] = "toggle_hidden",
						["<a-i>"] = "toggle_ignored",
						["<a-m>"] = "toggle_maximize",
						["<a-p>"] = "toggle_preview",
						["<a-w>"] = "cycle_win",
						-- ["<c-a>"] = "select_all",
						["<c-b>"] = "preview_scroll_up",
						["<c-d>"] = "list_scroll_down",
						["<c-f>"] = "preview_scroll_down",
						["<c-j>"] = "list_down",
						["<c-k>"] = "list_up",
						["<c-n>"] = "list_down",
						["<c-p>"] = "list_up",
						["<c-q>"] = "qflist",
						["<c-s>"] = "edit_split",
						["<c-t>"] = "tab",
						["<c-u>"] = "list_scroll_up",
						["<c-v>"] = "edit_vsplit",
						["<c-w>H"] = "layout_left",
						["<c-w>J"] = "layout_bottom",
						["<c-w>K"] = "layout_top",
						["<c-w>L"] = "layout_right",
						["?"] = "toggle_help_list",
						["G"] = "list_bottom",
						["gg"] = "list_top",
						["i"] = "focus_input",
						["j"] = "list_down",
						["k"] = "list_up",
						["q"] = "close",
						["zb"] = "list_scroll_bottom",
						["zt"] = "list_scroll_top",
						["zz"] = "list_scroll_center",
					},
					wo = {
						conceallevel = 2,
						concealcursor = "nvc",
					},
				},
				-- preview window
				preview = {
					keys = {
						["<Esc>"] = "cancel",
						["q"] = "close",
						["i"] = "focus_input",
						["<a-w>"] = "cycle_win",
					},
				},
			}
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
