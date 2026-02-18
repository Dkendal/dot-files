--#selene: allow(mixed_table)

-- Load init.d files
local init_files = vim.fs.find(function(name, _path)
	return name:match(".*%.lua")
end, {
	type = "file",
	limit = math.huge,
	path = vim.fs.joinpath(vim.fn.stdpath("config"), "init.d"),
})

table.sort(init_files)

for _, file in ipairs(init_files) do
	dofile(file)
end

---@type LazyPluginSpec[]
local plugins = {
	-- Filetype plugins
	{
		"elixir-editors/vim-elixir",
		lazy = true,
		ft = "elixir",
	},

	{ "pest-parser/pest.vim", ft = "pest" },

	{ "terrastruct/d2-vim", ft = "d2" },

	{
		"https://github.com/kaarmu/typst.vim",
		ft = "typst",
	},

	{
		dir = "~/src/dkendal/nvim-kitty",
		opts = {
			snacks = true,
		},
		rocks = {
			"lpeg-label",
		},
		dependencies = {
			"folke/snacks.nvim",
		},
		keys = {
			{
				"<leader>sp",
				function()
					require("nvim-kitty.snacks").picker()
				end,
			},
		},
	},

	{
		dir = "~/src/dkendal/nvim-treeclimber",
		opts = {
			highlight = 60,
		},
		keys = {
			-- Core navigation
			{
				"<M-h>",
				"<Plug>(treeclimber-select-previous)",
				mode = { "n", "x", "o" },
				desc = "Select previous node",
			},
			{
				"<M-l>",
				"<Plug>(treeclimber-select-next)",
				mode = { "n", "x", "o" },
				desc = "Select next node",
			},
			{
				"<M-k>",
				"<Plug>(treeclimber-select-parent)",
				mode = { "n", "x", "o" },
				desc = "Select parent node",
			},
			{
				"<M-j>",
				"<Plug>(treeclimber-select-shrink)",
				mode = { "n", "x", "o" },
				desc = "Select child node",
			},
			-- Growth selection
			{
				"<M-H>",
				"<Plug>(treeclimber-select-grow-backward)",
				mode = { "n", "x", "o" },
				desc = "Grow selection backward",
			},
			{
				"<M-L>",
				"<Plug>(treeclimber-select-grow-forward)",
				mode = { "n", "x", "o" },
				desc = "Grow selection forward",
			},
			-- Sibling navigation
			{
				"<M-[>",
				"<Plug>(treeclimber-select-siblings-backward)",
				mode = { "n", "x", "o" },
				desc = "Select first sibling",
			},
			{
				"<M-]>",
				"<Plug>(treeclimber-select-siblings-forward)",
				mode = { "n", "x", "o" },
				desc = "Select last sibling",
			},
			-- Top level
			{
				"<M-g>",
				"<Plug>(treeclimber-select-top-level)",
				mode = { "n", "x", "o" },
				desc = "Select top-level node",
			},
			-- Movement selection
			{
				"<M-b>",
				"<Plug>(treeclimber-select-backward)",
				mode = { "n", "x", "o" },
				desc = "Select and move to node start",
			},
			{
				"<M-e>",
				"<Plug>(treeclimber-select-forward-end)",
				mode = { "n", "x", "o" },
				desc = "Select and move to node end",
			},
			-- Visual/operator mode specific
			{
				"i.",
				"<Plug>(treeclimber-select-current-node)",
				mode = { "x", "o" },
				desc = "Select current node (inner)",
			},
			{
				"a.",
				"<Plug>(treeclimber-select-expand)",
				mode = { "x", "o" },
				desc = "Select parent node (around)",
			},
			-- Commands
			{
				"<leader>k",
				"<Plug>(treeclimber-show-control-flow)",
				mode = "n",
				desc = "Show control flow",
			},
		},
		cmd = { "TCDiffThis", "TCShowControlFlow", "TCHighlightExternalDefinitions" },
	},

	{
		"nvimtools/none-ls.nvim",
		lazy = true,
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				root_dir = require("null-ls.utils").root_pattern(".git", "package.json"),
				debug = false,
				sources = {},
			})
		end,
	},

	{
		"nvimdev/lspsaga.nvim",
		opts = {
			lightbulb = {
				sign = false,
			},
		},
		event = "LspAttach",
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
		keys = {
			{ "<c-.>", "<cmd>Lspsaga code_action<cr>" },
		},
	},

	{
		"vim-scripts/file-line",
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
		end,
	},

	{
		"folke/trouble.nvim",
		opts = {},
		maps = {
			{ "<leader>xx", "<cmd>Trouble diagnostics<cr>" },
			{ "<leader>xQ", "<cmd>Trouble quickfix<cr>" },
			{ "<leader>cs", "<cmd>Trouble symbols<cr>" },
			{ "<leader>cS", "<cmd>Trouble definitions<cr>" },
		},
	},

	{
		"numToStr/Comment.nvim",
		opts = {
			toggler = {
				-- Line-comment toggle keymap
				line = "<leader>;",
				-- Block-comment toggle keymap
				block = "<leader>:",
			},
			opleader = {
				-- Line-comment keymap
				line = "<leader>;",
				-- Block-comment keymap
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
			{ "<C-LeftMouse>", "<Plug>(VM-Mouse-Cursor)", mode = "n" },
			{ "<C-RightMouse>", "<Plug>(VM-Mouse-Word)", mode = "n" },
			{ "<M-C-RightMouse>", "<Plug>(VM-Mouse-Column)", mode = "n" },
			{ "<C-S-j>", "<Plug>(VM-Add-Cursor-Down)", mode = "n" },
			{ "<C-S-k>", "<Plug>(VM-Add-Cursor-Up)", mode = "n" },
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
		"chentoast/marks.nvim",
		opts = {},
	},

	{
		"https://github.com/stevearc/oil.nvim",
		dependencies = {
			"echasnovski/mini.icons",
			"nvim-tree/nvim-web-devicons",
		},
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
		},
	},

	{
		dir = "~/src/dkendal/nvim-alternate",
		lazy = false,
		opts = {
			rules = {
				-- Haskell
				{ glob = { "src/*.hs", "test/*Spec.hs" } },
				-- Elixir
				{ glob = { "lib/*.ex", "test/*_test.exs" } },
				{ glob = { "lib/*/live/*.ex", "lib/*/live/*.html.heex" } },
				{ glob = { "apps/*/lib/*.ex", "apps/*/test/*_test.exs" } },
				-- Ruby
				{ glob = { "app/*.rb", "test/*_test.rb" } },
				{ glob = { "test/*_test.rb", "app/*.rb" } },
				-- Lua
				{ glob = { "lua/*.lua", "tests/*_spec.lua" } },
				{ pattern = { "(.+).([jt]sx?)$", "%1.test.%2" } },
				{ pattern = { "(.+).test.([jt]sx?)$", "%1.%2" } },
			},
		},
		keys = {
			{ "<leader>pa", "<plug>(alternate-edit)" },
		},
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		dir = "~/src/dkendal/nvim-coverage",
		opts = {
			auto_reload = true,
			lang = {
				elixir = {
					coverage_file = function()
						return vim.fn.findfile("lcov.info", "cover,apps/*/cover")
					end,
				},
			},
		},
	},

	{
		"AndrewRadev/splitjoin.vim",
		lazy = true,
		keys = { "cS", "cJ" },
	},

	{
		"MagicDuck/grug-far.nvim",
		lazy = true,
		cmd = { "GrugFar", "GrugFarWithin" },
		opts = {},
	},

	{ "artnez/vim-wipeout" },

	{
		"blankname/vim-fish",
		lazy = true,
		ft = "fish",
	},

	{ "Mofiqul/vscode.nvim", lazy = true },

	{ "catppuccin/nvim", lazy = false },

	{ "j-hui/fidget.nvim", opts = {} },

	{ "jamessan/vim-gnupg" },

	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {},
		ft = {}
	},

	{
		"sindrets/diffview.nvim",
		lazy = true,
		cmd = {
			"DiffviewClose",
			"DiffviewFileHistory",
			"DiffviewFocusFiles",
			"DiffviewLog",
			"DiffviewOpen",
			"DiffviewToggleFiles",
		},
		opts = {},
	},
	{
		"julienvincent/hunk.nvim",
		cmd = { "DiffEditor" },
		config = function()
			require("hunk").setup()
		end,
	},

	{ "tpope/vim-abolish" },

	{ "tpope/vim-eunuch" },

	{ "tpope/vim-fugitive" },

	{ "tpope/vim-repeat" },

	{ "tpope/vim-rhubarb" },

	{ "tpope/vim-rsi" },

	{ "tpope/vim-scriptease" },

	{ "tpope/vim-sleuth" },

	{ "tpope/vim-speeddating" },

	{ "tpope/vim-unimpaired" },

	{ "uga-rosa/ccc.nvim", opts = {} },
	{
		"mason-org/mason.nvim",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		},
	},

	-- TODO move these to dependencies
	{ "ryanoasis/vim-devicons" },
	{ "nvim-tree/nvim-web-devicons" },
}

local opts = {
	checker = { enabled = false },
}

function Reload(mod)
	package.loaded[mod] = nil
	return require(mod)
end

require("lazy").setup({
	{ import = "plugins" },
	plugins,
}, opts)
require("user.boxes")
require("user.background").init()
require("user.projects")

vim.o.exrc = true
vim.o.secure = true
