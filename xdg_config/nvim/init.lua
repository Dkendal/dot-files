--#selene: allow(mixed_table)

-- Load init.d files
local init_files = vim.fs.find(function(name, path)
	return name:match(".*%.lua")
end, {
	type = "file",
	limit = math.huge,
	path = vim.fs.joinpath(vim.fn.stdpath("config"), "init.d")
})

table.sort(init_files)

for _, file in ipairs(init_files) do dofile(file) end

local plugins = {
	{
		dir = "~/src/dkendal/nvim-kitty",
		opts = {
			snacks = true
		},
		rocks = {
			"lpeg-label"
		},
		dependencies = {
			"folk/snacks.nvim"
		},
		keys = {
			{"<leader>sp", function() require("nvim-kitty.snacks").picker() end}
		}
	},

	{ dir = "~/src/dkendal/nvim-treeclimber",    opts = {}, },

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

					hl.set(0, "StatusLineDiagnosticError", { bg = StatusLine.fg, fg = colors.DarkRed, bold = true })
					hl.set(0, "StatusLineDiagnosticWarn", { bg = StatusLine.fg, fg = colors.DarkOrange, bold = true })
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
			require("user.lsp").setup()
		end,
	},

	{
		"nvimdev/lspsaga.nvim",
		opts = {
			lightbulb = {
				sign = false
			}
		},
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
		"Saghen/blink.cmp",
		dependencies = 'rafamadriz/friendly-snippets',
		version = "*",
		--@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
		},
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},
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
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/playground",
			"rrethy/nvim-treesitter-textsubjects",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		init = function()
			local configs = require("nvim-treesitter.configs")

			local parsers = require("nvim-treesitter.parsers")

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
					dir = "OilDir",
					expand_marker = "NeotestExpandMarker",
					failed = "healthError",
					file = "OilDir",
					focused = "NeotestFocused",
					indent = "NeotestIndent",
					marked = "NeotestMarked",
					namespace = "NeotestNamespace",
					passed = "healthSuccess",
					running = "healthWarning",
					select_win = "NeotestWinSelect",
					skipped = "healthWarning",
					target = "NeotestTarget",
					test = "NeotestTest",
					unknown = "NeotestUnknown",
				},
			})
		end,
		keys = {
			{ "<leader>tl", "<cmd>Neotest run last<cr>" },
			{ "<leader>tt", "<cmd>Neotest run file<cr>" },
			{ "<leader>tf", function() require('neotest').run.run(vim.fn.expand("%")) end, "Test whole file" },
			{ "<leader>tq", "<cmd>Neotest stop<cr>" },
			{ "<leader>to", "<cmd>Neotest output<cr>" },
			{ "<leader>tO", "<cmd>Neotest output-panel<cr>" },
			{ "<leader>ts", "<cmd>Neotest summary<cr>" },
			{ "<leader>ta", "<cmd>Neotest attach<cr>" },
		},
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
		"https://github.com/kaarmu/typst.vim",
		ft = "typst",
		lazy = false,
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
			"echasnovski/mini.diff",
			{
				"stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
				opts = {},
			},
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
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},

	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			indent = {},
			picker = {},
			bigfile = {},
			quickfile = {},
			scroll = {},
			statuscolumn = {},
			gitbrowse = {},
			image = {},
			notifier = {},
		},
		keys = {
			-- Scratch
			{ "<leader>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
			{ "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
			-- Spell check
			{ "s=",              function() Snacks.picker.spelling() end,                                desc = "Correct spelling" },
			-- Top Pickers & Explorer
			{ "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
			{ "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
			{ "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
			{ "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
			{ "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
			{ "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },
			-- find
			{ "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
			{ "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
			{ "<leader>fd",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("data") }) end,   desc = "Find Data File" },
			{ "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
			{ "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
			{ "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
			{ "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
			-- git
			{ "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
			{ "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
			{ "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
			{ "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
			{ "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
			{ "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
			{ "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
			-- Grep
			{ "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
			{ "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
			{ "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
			{ "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
			-- search
			{ '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
			{ '<leader>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
			{ "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
			{ "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
			{ "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
			{ "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
			{ "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
			{ "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
			{ "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
			{ "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
			{ "<leader>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
			{ "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
			{ "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
			{ "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
			{ "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
			{ "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
			{ "<leader>sP",      function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
			{ "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
			{ "<leader>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
			{ "<leader>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
			{ "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
			-- LSP
			{ "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
			{ "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
			{ "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
			{ "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
			{ "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
			{ "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
			{ "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
		}
	},

	{ "AndrewRadev/splitjoin.vim", },
	{ "MagicDuck/grug-far.nvim",                 opts = {} },
	{ "Mofiqul/vscode.nvim",                     lazy = true },
	{ "artnez/vim-wipeout", },
	{ "blankname/vim-fish", },
	{ "catppuccin/nvim", },
	{ "elixir-editors/vim-elixir", },
	{ "folke/neodev.nvim",                       opts = {} },
	{ "godlygeek/tabular", },
	{ "https://github.com/LhKipp/nvim-nu",       opts = {}, },
	{ "j-hui/fidget.nvim",                       opts = {} },
	{ "jamessan/vim-gnupg", },
	{ "kevinhwang91/promise-async", },
	{ "nvim-lua/plenary.nvim", },
	{ "nvim-tree/nvim-web-devicons", },
	{ "nvim-treesitter/nvim-treesitter-context", opts = {}, },
	{ "pest-parser/pest.vim",                    filetypes = { "pest" } },
	{ "ryanoasis/vim-devicons", },
	{ "sindrets/diffview.nvim",                  opts = {}, },
	{ "terrastruct/d2-vim", },
	{ "tpope/vim-abolish", },
	{ "tpope/vim-eunuch", },
	{ "tpope/vim-fugitive", },
	{ "tpope/vim-repeat", },
	{ "tpope/vim-rhubarb", },
	{ "tpope/vim-rsi", },
	{ "tpope/vim-scriptease", },
	{ "tpope/vim-sleuth", },
	{ "tpope/vim-speeddating", },
	{ "tpope/vim-unimpaired", },
	{ "uga-rosa/ccc.nvim",                       opts = {}, },
}

local opts = {}

require("lazy").setup(plugins, opts)
require("user.boxes")
require("user.background").init()
require("user.projects")

vim.o.exrc = true
vim.o.secure = true
