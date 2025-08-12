return {
		"nvim-neotest/neotest",
		lazy = true,
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
					failed = "",
					final_child_indent = " ",
					final_child_prefix = "╰",
					non_collapsible = "─",
					notify = "󰂚",
					passed = "",
					running = "",
					running_animated = {
						"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", ""
					},
					skipped = "",
					unknown = "",
					watching = "󰐃"
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
			{ "[t",         "<cmd>Neotest jump prev<cr>" },
			{ "]t",         "<cmd>Neotest jump next<cr>" },
			{ "<leader>tl", "<cmd>Neotest run last<cr>" },
			{ "<leader>tt", "<cmd>Neotest run file<cr>" },
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				"Test whole file",
			},
			{ "<leader>tq", "<cmd>Neotest stop<cr>" },
			{ "<leader>to", "<cmd>Neotest output<cr>" },
			{ "<leader>tO", "<cmd>Neotest output-panel<cr>" },
			{ "<leader>ts", "<cmd>Neotest summary<cr>" },
			{ "<leader>ta", "<cmd>Neotest attach<cr>" },
		},
	}
