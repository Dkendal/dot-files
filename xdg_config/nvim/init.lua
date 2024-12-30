--#selene: allow(mixed_table)

local init_files = vim.fs.find(function(name, path)
	return name:match(".*%.lua")
end, {
	type = "file",
	limit = math.huge,
	path = vim.fs.joinpath(vim.fn.stdpath("config"), "init.d")
})

for _, file in ipairs(init_files) do
	dofile(file)
end

local safe_require = require("user.package").safe_require

vim.cmd.packadd("cfilter")

local plugins = {
	{
		"catppuccin/nvim",
	},
	{
		"morhetz/gruvbox",
		config = function()
			vim.g.gruvbox_contrast_dark = "hard"
			vim.g.gruvbox_contrast_light = "medium"
			vim.g.gruvbox_improved_strings = 1
			vim.g.gruvbox_bold = 1
			vim.g.gruvbox_italic = 1
			vim.g.gruvbox_underline = 1
			vim.g.gruvbox_undercurl = 1
			vim.g.gruvbox_number_column = "bg0"
			vim.g.gruvbox_sign_column = "bg1"
			vim.g.gruvbox_color_column = "bg1"
			vim.g.gruvbox_vert_split = "bg0"
			vim.g.gruvbox_italicize_comments = 1
			vim.g.gruvbox_improved_strings = 0
			vim.g.gruvbox_improved_warnings = 1

			vim.api.nvim_create_autocmd({ "ColorScheme" }, {
				pattern = "gruvbox",
				callback = function()
					local hl = require("user.highlight")

					local colors = hl.color_map()
					local Normal = hl.get(0, { name = "Normal" })
					local StatusLine = hl.get(0, { name = "StatusLine" })
					local background = vim.o.background

					hl.SignColumn = Normal

					-- Customization on top of Gruvbox
					hl.set(0, "@module", { link = "Structure" })

					hl.set(0, "@markup.heading.1", { link = "GruvboxRed" })
					hl.set(0, "@markup.heading.2", { link = "GruvBoxGreen" })
					hl.set(0, "@markup.heading.3", { link = "GruvboxYellow" })
					hl.set(0, "@markup.heading.4", { link = "GruvboxBlue" })
					hl.set(0, "@markup.raw.block", { link = "GruvBoxFg4" })

					-- NeoTest
					hl.set(0, "NeotestFailed", { link = "GruvboxRedSign" })
					hl.set(0, "NeotestPassed", { link = "GruvboxGreenSign" })
					hl.set(0, "NeotestRunning", { link = "GruvboxBlueSign" })
					hl.set(0, "NeotestSkipped", { link = "GruvboxYellowSign" })

					if background == "dark" then
						hl.set(0, "Visual", { bg = Normal.bg.li(15).de(10) })
					else
						hl.set(0, "Visual", { bg = Normal.bg.da(15).de(10) })
					end

					-- Menus
					local float_bg = Normal.bg.da(5).de(50)
					hl.set(0, "Pmenu", { bg = float_bg })
					hl.set(0, "NormalFloat", { bg = float_bg })
					hl.set(0, "FloatBorder", { bg = float_bg, fg = float_bg.darken(10).de(30) })
					hl.set(0, "LspDiagnosticsDefaultHint", { link = "GruvboxBg4" })

					hl.set(0, "StatusLineDiagnosticWarn", { bg = StatusLine.fg, fg = colors.DarkOrange, bold = true })
					hl.set(0, "StatusLineDiagnosticError", { bg = StatusLine.fg, fg = colors.DarkRed, bold = true })
					hl.set(0, "StatusLineDiagnosticHint", { bg = StatusLine.fg, fg = colors.DarkBlue, bold = true })
					hl.set(0, "StatusLineDiagnosticInfo", { bg = StatusLine.fg, fg = colors.DarkCyan, bold = true })

					-- Web devicons
					for _, conf in pairs(require("nvim-web-devicons").get_icons()) do
						local name = string.format("StatusLineDevIcon%s", conf.name)
						hl.set(0, name, {
							bg = StatusLine.fg,
							fg = conf.color,
						})
					end

					for name, opts in pairs({
						Add = { "#9efaa4", "#00ff00" },
						Change = { "#ccfcff", "#ffff00" },
						Delete = { "#ff614d", "#ff0000" },
						Text = { "#ccfcff", "#ffff00" },
					}) do
						local light, dark = unpack(opts)
						local color = ""

						if background == "dark" then
							color = dark
						else
							color = light
						end

						hl.set(0, "Diff" .. name, { bg = color })
					end

					-- Treesitter Context
					hl.set(0, "TreesitterContextBottom", { underline = true })
				end,
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			local null_ls = require("null-ls")

			local h = require("null-ls.helpers")

			null_ls.setup({
				root_dir = require("null-ls.utils").root_pattern(".git", "package.json"),
				debug = true,
				sources = {
					-- Diagnostics
					null_ls.builtins.diagnostics.fish,
					null_ls.builtins.diagnostics.codespell,
					-- null_ls.builtins.diagnostics.selene,
					-- Formatting
					null_ls.builtins.formatting.shellharden,
					null_ls.builtins.formatting.erb_format,
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.shfmt,
					null_ls.builtins.formatting.rubocop,
					null_ls.builtins.formatting.mix,
					null_ls.builtins.formatting.gdformat,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.csharpier,
					null_ls.builtins.formatting.typstfmt,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"nvim-lua/lsp-status.nvim",
			"nvimtools/none-ls.nvim",
			"lvimuser/lsp-inlayhints.nvim",
			{ "ray-x/lsp_signature.nvim", opts = {} },
			{
				"williamboman/mason-lspconfig.nvim",
				opts = {},
				dependencies = {
					{
						"williamboman/mason.nvim",
						opts = {},
					},
				},
			},
		},
		init = function()
			require("user/lsp").setup()
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
		event = "LspAttach",
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons",  -- optional
		},
		keys = {
			{ "<c-.>",     "<cmd>Lspsaga code_action<cr>" },
			{ "<leader>o", "<cmd>Lspsaga outline<cr>" },
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"zbirenbaum/copilot-cmp",
			{
				"onsails/lspkind.nvim",

				config = function()
					require("lspkind").init({
						Copilot = "",
					})

					vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
				end,
			},
			"neovim/nvim-lspconfig",
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			require("user/snippets").setup()

			cmp.setup({
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = {
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-return>"] = cmp.mapping.confirm({ select = true }),
					["<C-g>"] = cmp.mapping.abort(),
					["<C-c>"] = cmp.mapping.abort(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-u>"] = cmp.mapping.scroll_docs(4),
					-- ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
				},
				experimental = {
					ghost_text = true,
				},
				formatting = {
					format = lspkind.cmp_format(),
				},
				sources = {
					{ name = "nvim_lsp_signature_help", group_index = 1 },
					{ name = "copilot",                 group_index = 2 },
					{ name = "user_snippets",           group_index = 2 },
					{ name = "nvim_lsp",                group_index = 2 },
					{ name = "nvim_lua",                group_index = 2 },
					{ name = "path",                    group_index = 3 },
					{ name = "emoji",                   group_index = 3 },
				},
			})
		end,
	},
	{
		"vim-scripts/file-line",
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "┃" },
				change = { text = "┇" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┇" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false,  -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			stages = "fade",
			render = "default",
			timeout = 1000,
		},
		init = function()
			vim.notify = require("notify")
			-- vim.api.nvim_set_hl(0, "NotifyBackground", { link = "Normal" })
		end,
		{
			"nvim-treesitter/nvim-treesitter",
			dependencies = {
				"nvim-treesitter/playground",
				"rrethy/nvim-treesitter-textsubjects",
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
			keys = {
				{ "<leader>tl", "<cmd>Neotest run last<cr>" },
				{ "<leader>tt", "<cmd>Neotest run file<cr>" },
				{ "<leader>tq", "<cmd>Neotest stop<cr>" },
				{ "<leader>to", "<cmd>Neotest output<cr>" },
				{ "<leader>tO", "<cmd>Neotest output-panel<cr>" },
				{ "<leader>ts", "<cmd>Neotest summary<cr>" },
				{ "<leader>ta", "<cmd>Neotest attach<cr>" },
			},
			init = function()
				local configs = require("nvim-treesitter.configs")

				local parsers = require("nvim-treesitter.parsers")

				local parser_configs = parsers.get_parser_configs()

				local setup = configs["setup"]

				setup({
					auto_install = true,
					sync_install = true,
					ignore_install = {},
					modules = {},
					ensure_installed = {},
					query_linter = {
						enable = true,
						use_virtual_text = true,
						lint_events = { "BufWrite", "CursorHold" },
					},
					textsubjects = {
						enable = true,
						prev_selection = ",", -- (Optional) keymap to select the previous selection
						keymaps = {
							["."] = "textsubjects-smart",
							[";"] = "textsubjects-container-outer",
							["i;"] = "textsubjects-container-inner",
						},
					},
					playground = {
						enable = true,
						disable = {},
						updatetime = 25,
						persist_queries = false,
						keybindings = {
							toggle_query_editor = "o",
							toggle_hl_groups = "i",
							toggle_injected_languages = "t",
							toggle_anonymous_nodes = "a",
							toggle_language_display = "I",
							focus_language = "f",
							unfocus_language = "F",
							update = "R",
							goto_node = "<cr>",
							show_help = "?",
						},
					},
					indent = { enable = true },
					highlight = {
						enable = true,
						custom_captures = {},
						disable = { "git", "gitcommit" },
					},
				})
			end,
		},
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			local ufo_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" 󰁂 %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			require("ufo").setup({
				preview = {
					win_config = {
						border = { '', '─', '', '', '', '─', '', '' },
						winblend = 0
					},
				},
				fold_virt_text_handler = ufo_handler,
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	},
	{
		"nvim-lua/plenary.nvim",
	},
	{
		"kevinhwang91/promise-async",
	},
	{
		"AndrewRadev/splitjoin.vim",
	},
	{
		"cshuaimin/ssr.nvim",
		opts = {
			min_width = 50,
			min_height = 5,
			keymaps = {
				close = "q",
				next_match = "n",
				prev_match = "N",
				replace_all = "<leader><cr>",
			},
		},
		keys = {
			{
				"<leader>sr",
				function()
					require("ssr").open()
				end,
				mode = "n",
			},
		},
	},
	{
		"godlygeek/tabular",
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				"Marskey/telescope-sg",
				"debugloop/telescope-undo.nvim",
				build = "make",
			},
		},
		config = function()
			local telescope = require("telescope")
			local themes = require("telescope.themes")
			telescope.setup({
				extensions = {
					fzf = {},
					ast_grep = {
						command = {
							"sg",
							"--json=stream",
						},                 -- must have --json=stream
						grep_open_files = false, -- search in opened files
						lang = nil,        -- string value, specify language for ast-grep `nil` for default
					}
				},
				defaults = themes.get_ivy({}),
			})
			telescope.load_extension("fzf")
			telescope.load_extension("undo")
			telescope.load_extension("kitty")
		end,
		keys = {
			{ "gO",          "<cmd>Telescope lsp_document_symbols<cr>",          desc = "Document symbols" },
			{ "<m-o>",       "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
			{ "<c-s-o>",     "<cmd>Telescope lsp_document_symbols<cr>",          desc = "Document symbols" },
			{ "<m-o>",       "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
			{ "<leader>bb",  "<cmd>Telescope buffers<cr>",                       desc = "Buffers" },
			{ "<leader>gla", "<cmd>Telescope git_commits<cr>",                   desc = "Git commits" },
			{ "<leader>glb", "<cmd>Telescope git_bcommits<cr>",                  desc = "Git bcommits" },
			{ "<leader>fer", ":Telescope reloader<cr>",                          desc = "Reload config" },
			{ "<leader>pf",  "<cmd>Telescope git_files<cr>",                     desc = "Git files" },
			{ "<leader>pg",  "<cmd>Telescope git_status<cr>",                    desc = "Git Status" },
			{ "<M-O>",       "<cmd>Telescope jumplist<cr>",                      desc = "Jumplist" },
			{ "<leader>lsd", "<cmd>Telescope lsp_document_symbols<cr>",          desc = "LSP: Document symbols" },
			{ "<leader>lsw", "<cmd>Telescope lsp_workspace_symbols<cr>",         desc = "LSP: Workspace Symbols" },
			{ "<leader>lsW", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "LSP: Dynamic Workspace Symbols" },
			{ "<leader>li",  "<cmd>Telescope lsp_incoming_calls<cr>",            desc = "LSP: Incoming calls" },
			{ "<leader>lo",  "<cmd>Telescope lsp_outgoing_calls<cr>",            desc = "LSP: Outgoing calls" },
		},
	},
	{
		"debugloop/telescope-undo.nvim",
		dependencies = { -- note how they're inverted to above example
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		opts = {
			extensions = {
				under = {},
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("undo")
		end,
		keys = {
			{
				"<leader>u",
				"<cmd>Telescope undo<cr>",
				desc = "Undo history",
			},
		},
	},
	{
		"folke/trouble.nvim",
		opts = {},
		maps = {
			{ "<leader>xx", "<cmd>Trouble diagnostics<cr>" },
			{ "<leader>xQ", "<cmd>Trouble quickfix<cr>" },
			{ "<leader>cs", "<cmd>Trouble symbols<cr>" },
			{ "<leader>cS", "<cmd>Trouble definitions<cr>" },
		}
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			toggler = {
				---Line-comment toggle keymap
				line = "<leader>;",
				---Block-comment toggle keymap
				block = "<leader>:",
			},
			opleader = {
				---Line-comment keymap
				line = "<leader>;",
				---Block-comment keymap
				block = "<leader>:",
			},
		},
	},
	{
		"machakann/vim-sandwich",
		config = function()
			vim.cmd([[runtime macros/sandwich/keymap/surround.vim]])

			local t = vim.deepcopy(vim.g["sandwich#default_recipes"])

			table.insert(t, {
				buns = { "<%= ", " %>" },
				input = { "=" },
			})

			table.insert(t, {
				buns = { "<% ", " %>" },
				input = { "-" },
			})

			vim.g["sandwich#recipes"] = t
		end,
	},
	"tpope/vim-scriptease",
	"tpope/vim-sleuth",
	"tpope/vim-speeddating",
	"tpope/vim-unimpaired",
	{
		"mg979/vim-visual-multi",
		keys = {
			{ "<C-LeftMouse>",    "<Plug>(VM-Mouse-Cursor)",    mode = "n" },
			{ "<C-RightMouse>",   "<Plug>(VM-Mouse-Word)",      mode = "n" },
			{ "<M-C-RightMouse>", "<Plug>(VM-Mouse-Column)",    mode = "n" },
			{ "<C-S-j>",          "<Plug>(VM-Add-Cursor-Down)", mode = "n" },
			{ "<C-S-k>",          "<Plug>(VM-Add-Cursor-Up)",   mode = "n" },
		},
		lazy = false,
		init = function()
			vim.g.vm_theme = "paper"
		end,
	},
	"artnez/vim-wipeout",
	{ "folke/neodev.nvim",    opts = {} },
	{
		"nvim-colortils/colortils.nvim",
		opts = {
			-- Register in which color codes will be copied
			register = "+",
			-- Preview for colors, if it contains `%s` this will be replaced with a hex color code of the color
			color_preview = "█ %s",
			-- The default in which colors should be saved
			-- This can be hex, hsl or rgb
			default_format = "hex",
			-- Border for the float
			border = "rounded",
			-- Some mappings which are used inside the tools
			mappings = {
				-- increment values
				increment = "l",
				-- decrement values
				decrement = "h",
				-- increment values with bigger steps
				increment_big = "L",
				-- decrement values with bigger steps
				decrement_big = "H",
				-- set values to the minimum
				min_value = "0",
				-- set values to the maximum
				max_value = "$",
				-- save the current color in the register specified above with the format specified above
				set_register_default_format = "<cr>",
				-- save the current color in the register specified above with a format you can choose
				set_register_cjoose_format = "g<cr>",
				-- replace the color under the cursor with the current color in the format specified above
				replace_default_format = "<m-cr>",
				-- replace the color under the cursor with the current color in a format you can choose
				replace_choose_format = "g<m-cr>",
				-- export the current color to a different tool
				export = "E",
				-- set the value to a certain number (done by just entering numbers)
				set_value = "c",
				-- toggle transparency
				transparency = "T",
				-- choose the background (for transparent colors)
				choose_background = "B",
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		opts = {},
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			-- dependencies
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- adapters
			"jfpedroza/neotest-elixir",
			"nvim-neotest/neotest-plenary",
			"rouge8/neotest-rust",
			"https://gitlab.com/HiPhish/neotest-busted.git",
		},

		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-elixir"),
					require("neotest-rust"),
					require("neotest-busted"),
				},
				icons = {
					child_indent = "│",
					child_prefix = "├",
					collapsed = "─",
					expanded = "╮",
					failed = "✖",
					final_child_indent = " ",
					final_child_prefix = "╰",
					non_collapsible = "─",
					passed = "✔",
					running = "◯",
					skipped = "ﰸ",
					unknown = "?",
				},
				highlights = {
					adapter_name = "NeotestAdapterName",
					border = "NeotestBorder",
					dir = "NeotestDir",
					expand_marker = "NeotestExpandMarker",
					failed = "NeotestFailed",
					file = "NeotestFile",
					focused = "NeotestFocused",
					indent = "NeotestIndent",
					marked = "NeotestMarked",
					namespace = "NeotestNamespace",
					passed = "NeotestPassed",
					running = "NeotestRunning",
					select_win = "NeotestWinSelect",
					skipped = "NeotestSkipped",
					target = "NeotestTarget",
					test = "NeotestTest",
					unknown = "NeotestUnknown",
				},
			})
		end,
	},
	"tpope/vim-abolish",
	"nvim-tree/nvim-web-devicons",
	"ryanoasis/vim-devicons",
	"elixir-editors/vim-elixir",
	"tpope/vim-eunuch",
	"blankname/vim-fish",
	"tpope/vim-fugitive",
	"jamessan/vim-gnupg",
	"tpope/vim-repeat",
	"tpope/vim-rhubarb",
	"tpope/vim-rsi",
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {},
	},
	{
		"https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
		opts = {},
		config = function()
			-- This module contains a number of default definitions
			local rainbow_delimiters = require("rainbow-delimiters")

			---@type rainbow_delimiters.config
			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				priority = {
					[""] = 110,
					lua = 210,
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			}
		end,
	},
	{
		"https://github.com/LhKipp/nvim-nu",
		opts = {},
	},
	{
		"https://github.com/kaarmu/typst.vim",
		ft = "typst",
		lazy = false,
	},
	-- Color Space Highlights
	{
		"uga-rosa/ccc.nvim",
		opts = {},
	},
	{
		"folke/paint.nvim",
		opts = {
			highlights = {
				{
					filter = { filetype = "fugitive" },
					pattern = "^M",
					hl = "DiffChange",
				},
				{
					filter = { filetype = "fugitive" },
					pattern = "^A",
					hl = "DiffAdd",
				},
				{
					filter = { filetype = "fugitive" },
					pattern = "^D",
					hl = "DiffDelete",
				},
			},
		},
	},
	{
		"chentoast/marks.nvim",
		config = function()
			require("marks").setup({})

			vim.api.nvim_create_autocmd({ "ColorScheme" }, {
				pattern = "gruvbox",
				callback = function()
					local hl = require("user.highlight")
					require("user.highlight").set(0, "MarkSignHL", { link = "GruvboxPurpleSign" })
				end,
			})
		end,
	},
	{ "Mofiqul/vscode.nvim",  lazy = true },
	{ "pest-parser/pest.vim", filetypes = { "pest" } },
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			update_to_buf_dir = { enable = false },
		},
		keys = {
			{ "<leader>-", "<cmd>NvimTreeToggle<cr>" },
			{ "<leader>=", "<cmd>NvimTreeFindFile<cr>" },
		},
	},
	{
		"https://github.com/stevearc/oil.nvim",
		dependencies = {
			"echasnovski/mini.icons",
			"nvim-tree/nvim-web-devicons"
		},
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" }
		}
	},
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>hdc",     "<cmd>FzfLua colorschemes<cr>" },
			{ "<leader>:",       "<cmd>FzfLua command_history<cr>",                             desc = "Command History" },
			{ "<leader>sc",      "<cmd>FzfLua command_history<cr>",                             desc = "Command History" },
			{ "<leader><space>", "<cmd>FzfLua commands<cr>" },
			{ "<leader>sd",      "<cmd>FzfLua diagnostics_document<cr>",                        desc = "Document Diagnostics" },
			{ "<leader>sD",      "<cmd>FzfLua diagnostics_workspace<cr>",                       desc = "Workspace Diagnostics" },
			{ "<leader>fel",     "<cmd>FzfLua files cwd=" .. vim.fn.stdpath("config") .. "<cr>" },
			{ "<leader>feL",     "<cmd>FzfLua files cwd=" .. vim.fn.stdpath("data") .. "<cr>" },
			{ "<leader>ff",      "<cmd>FzfLua files<cr>" },
			{ "<leader>sg",      "<cmd>FzfLua grep<CR>" },
			{ "<leader>?",       "<cmd>FzfLua grep<cr>" },
			{ "<leader>sgg",     "<cmd>FzfLua grep_curbuf<CR>" },
			{ "<leader>sgq",     "<cmd>FzfLua grep_quickfix<CR>" },
			{ "<leader>sgv",     "<cmd>FzfLua grep_visual<CR>" },
			{ "<leader>hh",      "<cmd>FzfLua helptags<cr>" },
			{ "<leader>hdh",     "<cmd>FzfLua highlights<cr>",                                  desc = "Highlights" },
			{ "<leader>sj",      "<cmd>FzfLua jumps<cr>",                                       desc = "Jumplist" },
			{ "<leader>hdm",     "<cmd>FzfLua keymaps<cr>" },
			{ "<leader>sk",      "<cmd>FzfLua keymaps<cr>",                                     desc = "Key Maps" },
			{ "<leader>/",       "<cmd>FzfLua live_grep<cr>" },
			{ "<leader>sl",      "<cmd>FzfLua loclist<cr>",                                     desc = "Location List" },
			{ "gD",              "<cmd>FzfLua lsp_declarations<CR>" },
			{ "gd",              "<cmd>FzfLua lsp_definitions<CR>" },
			{ "<leader>ss",      "<cmd>FzfLua lsp_document_symbol<CR>" },
			{ "gI",              "<cmd>FzfLua lsp_implementations<CR>" },
			{ "gr",              "<cmd>FzfLua lsp_references<CR>" },
			{ "gy",              "<cmd>FzfLua lsp_typedefs<CR>" },
			{ "<leader>sS",      "<cmd>FzfLua lsp_workspace_symbols<CR>" },
			{ "<leader>hm",      "<cmd>FzfLua manpages<cr>" },
			{ "<leader>sm",      "<cmd>FzfLua marks<cr>",                                       desc = "Jump to Mark" },
			{ "<leader>fr",      "<cmd>FzfLua oldfiles<CR>",                                    desc = "Old Files" },
			{ "<leader>sR",      "<cmd>FzfLua resume<cr>",                                      desc = "Resume" },
		},
		config = function()
			require("fzf-lua").setup({
				keymap = {
					builtin = {
						["<PageDown>"] = "preview-page-down",
						["<PageUp>"]   = "preview-page-up",
						["<Home>"]     = "preview-up",
						["<End>"]      = "preview-down",
					},
					fzf = {
						["pgdn"] = "preview-page-down",
						["pgup"] = "preview-page-up",
						["home"] = "preview-up",
						["end"]  = "preview-down",
					},
				}
			})
		end
	},
	{
		dir = "~/src/dkendal/fzf-lua-sapling",
		opts = {},
		dependencies = {
			"ibhagwan/fzf-lua"
		},
		keys = {
			-- { "<leader>pq", "<plug>(kitty-paths)" },
		},
		lazy = false,
	},
	{
		dir = "~/src/dkendal/nvim-kitty",
		opts = {},
		rocks = {
			"lpeg-label"
		},
		keys = {
			{ "<leader>pq", "<plug>(kitty-paths)" },
		},
	},
	{
		dir = "~/src/dkendal/nvim-treeclimber",
		opts = {},
	},
	{
		dir = "~/src/dkendal/nvim-alternate",
		lazy = false,
		opts = {
			pairs = {
				-- Haskell
				{ "src/*.hs",        "test/*Spec.hs" },
				-- Elixir
				{ "lib/*.ex",        "test/*_test.exs" },
				{ "lib/*/live/*.ex", "lib/*/live/*.html.heex" },
				{ "apps/*/lib/*.ex", "apps/*/test/*_test.exs" },
				-- Ruby
				{ "app/*.rb",        "test/*_test.rb" },
				{ "test/*_test.rb",  "app/*.rb" },
				-- Lua
				{ "lua/*.lua",       "tests/*_spec.lua" },
				{
					{ "*.ts", "*.tsx", "*.js", "*.jsx" },
					"(.+).([jt]sx?)",
					"%1.test.%2"
				},
				{
					{ "*.test.ts", "*.test.tsx", "*.js", "*.jsx" },
					"(.+).test.([jt]sx?)",
					"%1.%2"
				},
			}
		},
		keys = {
			{ "<leader>pa", "<plug>(alternate-edit)" }
		}
	},
	{
		"David-Kunz/gen.nvim",
		opts = {
			model = "llama3.1:latest",
			host = "titan.local",
			port = 11434,
			-- command = function(options)
			-- 	local body = { model = options.model, stream = true }
			-- 	return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
			-- end,
		}
	},
	{
		"olimorris/codecompanion.nvim",
		config = function()
			require("codecompanion").setup({
				strategies = {
					chat = {
						adapter = "anthropic",
					},
					inline = {
						adapter = "anthropic",
					},
					agent = {
						adapter = "anthropic",
					},
				},
				adapters = {
					openai = nil,
					anthropic = function()
						return require("codecompanion.adapters").extend("anthropic", {
							env = {
								api_key = "ANTHROPIC_API_KEY"
							},
						})
					end,
					copilot = nil,
					llama3 = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "llama3.1",
							schema = {
								model = {
									default = "llama3.1:latest",
								},
								num_ctx = {
									default = 4096,
								},
								num_predict = {
									default = -1,
								},
							},
							env = {
								url = "http://titan.local:11434",
							},
							headers = {
								["Content-Type"] = "application/json",
							},
							parameters = {
								sync = true,
							},
						})
					end,
					deepseek_coder_v2 = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "Deep Seek Coder v2",
							schema = {
								model = {
									default = "deepseek-coder-v2:latest",
								},
								num_ctx = {
									default = 4096,
								},
								num_predict = {
									default = -1,
								},
							},
							env = {
								url = "http://titan.local:11434",
							},
							headers = {
								["Content-Type"] = "application/json",
							},
							parameters = {
								sync = true,
							},
						})
					end,
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
			"echasnovski/mini.diff",
			{
				"stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
				opts = {},
			},
			"nvim-telescope/telescope.nvim", -- Optional: For using slash commands
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = {
					enabled = true,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>"
					},
					layout = {
						position = "bottom", -- | top | left | right
						ratio = 0.4
					},
				},
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = {
			"zbirenbaum/copilot.lua",
		},
		config = function()
			require("copilot_cmp").setup()
		end
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	}
}

local opts = {}

require("lazy").setup(plugins, opts)

require("user/boxes")
require("user/background").init()
require("user/statusline").setup()
require("user/keymaps").setup()
require("user/commands")
require("user/projects")
require("user/search_and_replace")

--- Enable persistant colorscheme changes
--- @param default_colorscheme string
--- @param default_background "dark" | "light"
--- @return nil
local function enable_persistant_colorscheme_changes(default_colorscheme, default_background)
	local data = vim.fn.stdpath("data")
	assert(type(data) == "string", "data is not a string")
	local colorscheme_file = vim.fs.joinpath(data, "colorscheme")

	if vim.fn.filereadable(colorscheme_file) == 1 then
		local color_data = vim.fn.readfile(colorscheme_file)
		assert(type(color_data) == "table", "data is not a table")
		assert(#color_data == 2, "data is not the correct length")
		vim.o.background = color_data[1]
		vim.cmd("colorscheme " .. color_data[2])
	else
		vim.o.background = default_background
		vim.cmd("colorscheme " .. default_colorscheme)
	end

	vim.api.nvim_create_autocmd({ "ColorScheme" }, {
		pattern = "*",
		callback = function()
			assert(type(data) == "string", "data is not a string")
			vim.fn.writefile({ vim.o.background, vim.g.colors_name }, colorscheme_file)
		end,
	})
end

enable_persistant_colorscheme_changes("gruvbox", "light")

vim.o.exrc = true
vim.o.secure = true
