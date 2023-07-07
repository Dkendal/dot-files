local util = require("user.util")
local map = util.map

local function pack_name(name)
	return table.concat(vim.split(name, "/", { plain = true }), ".")
end

local function clone_pack_from_github(name)
	local original_name = name
	name = pack_name(name)

	-- Install the pack if it's not installed via git
	vim.notify(string.format("Installing %s", name))

	ok = xpcall(function()
		vim.fn.system(
			string.format(
				"git clone git@github.com:%s.git ~/.config/nvim/pack/plugins/opt/%s --depth=1",
				original_name,
				name
			)
		)
	end, function(err)
		vim.print(string.format("Error installing %s: %s", name, vim.inspect(err)))
	end)

	if ok then
		vim.notify(string.format("Installed %s", name))
		vim.cmd(string.format("packadd %s", name))
	end
end

_G.user_clone_pack_from_github = clone_pack_from_github

local function packadd(name, cb)
	local original_name = name
	name = pack_name(name)

	local ok, res = xpcall(function()
		vim.cmd.packadd(name)
		if cb then
			cb()
		end
	end, debug.traceback)

	if not ok then
		vim.notify(string.format("Error loading %s: %s", name, res), vim.log.levels.ERROR)
		clone_pack_from_github(original_name)
	end
end

---@param f function
local function protected(f)
	return xpcall(f, function(err)
		vim.notify_once(vim.inspect(err), vim.log.levels.ERROR)
	end)
end

---@param pkgname string Name of the lua module to test for installation
---@param modname string Name of the lua rock package
--- Check if a lua rock is installed and install it if not
local function ensure_rock(_pkgname, modname)
	local ok, _res = pcall(require, modname)
	if not ok then
		vim.notify(string.format("Installing %s", modname), vim.log.levels.INFO)
		local res
		ok, res = pcall(vim.fn.system, string.format("luarocks install %s", modname))
		if not ok then
			vim.notify(string.format("Error installing %s: %s", modname, res), vim.log.levels.ERROR)
		end
	end
end

local function safe_require(name, f)
	local ok, res = xpcall(require, debug.traceback, name)

	if not ok then
		vim.notify(string.format("Error loading %s: %s", name, res), vim.log.levels.ERROR)
	end

	if f then
		f(res)
	end
end

ensure_rock("penlight", "pl")

local L = require("pl.utils").string_lambda

packadd("impatient.nvim")
require("impatient")

require("user/globals")
require("user/options")

-- Built-in
packadd("cfilter")
packadd("matchit")

-- User packs
packadd("nvim-gh")
packadd("nvim-treeclimber")

-- 3rd party packs

packadd("FixCursorHold.nvim")

packadd("LuaSnip", function()
	safe_require("user/snippets")
	map("n", "<leader>lsu", "<cmd>:LuaSnipUnlinkCurrent<cr>")
	map("n", "<leader>lsl", "<cmd>:LuaSnipListAvailable<cr>")
end)

packadd("NrrwRgn")

-- CMP
packadd("cmp-buffer")
packadd("cmp-calc")
packadd("cmp-emoji")
packadd("cmp-nvim-lsp")
packadd("cmp-nvim-lsp-document-symbol")
packadd("cmp-nvim-lua")
packadd("cmp-path")

packadd("cmp_luasnip")
packadd("nvim-cmp", function()
	require("user/cmp")
end)

packadd("copilot.vim", function()
	vim.fn.jobstart({ "rtx", "where", "nodejs@16" }, {
		stdout_buffered = true,
		on_stdout = function(j, d, e)
			local path = vim.trim(table.concat(d, ""))
			if type(path) == "string" and path ~= "" then
				vim.g.copilot_node_command = path
			end
		end,
	})

	vim.g.copilot_filetypes = {
		Prompt = false,
		TelescopePrompt = false,
	}
end)

packadd("earthly.vim")
packadd("file-line")
packadd("fzf")
packadd("fzf.vim")
packadd("gitsigns.nvim")
packadd("gruvbox")
packadd("hydra.nvim")
packadd("indent-blankline.nvim")
packadd("lsp-inlayhints.nvim")

packadd("lsp-status.nvim")

packadd("lspkind-nvim")
packadd("lush.nvim")
packadd("mason-lspconfig.nvim")
packadd("mason.nvim")
packadd("neotest")
packadd("neotest-elixir")
packadd("neotest-plenary")
packadd("null-ls.nvim")
packadd("nvim")
packadd("nvim-dap")
packadd("nvim-lspconfig")

packadd("nvim-notify", function()
	vim.api.nvim_set_hl(0, "NotifyBackground", { link = "Normal" })

	local notify = require("notify")

	notify.setup({
		stages = "fade",
		render = "default",
		timeout = 1000,
	})

	vim.notify = notify
end)

packadd("nvim-treesitter")
packadd("nvim-treesitter-textobjects")
packadd("nvim-treesitter-textsubjects")
packadd("nvim-ts-rainbow")

packadd("nvim-ufo", function()
	local ufo_handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = ("  %d "):format(endLnum - lnum)
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
		fold_virt_text_handler = ufo_handler,
		provider_selector = function(bufnr, filetype, buftype)
			return { "treesitter", "indent" }
		end,
	})
end)

packadd("nvim-web-devicons")
packadd("octo.nvim")
packadd("playground")
packadd("plenary.nvim")
packadd("promise-async")
packadd("splitjoin.vim")
packadd("ssr.nvim")
packadd("stabilize.nvim")
packadd("startuptime.vim")
packadd("symbols-outline.nvim")
packadd("tabular")

packadd("telescope.nvim", function ()
	packadd("telescope-fzf-native.nvim")
	local telescope = require("telescope")
	local themes = require("telescope.themes")

	telescope.setup({ extensions = { fzf = {} }, defaults = themes.get_ivy({}) })
	telescope.load_extension("fzf")
end)

packadd("trouble.nvim", function() end)

packadd("twilight.nvim")
packadd("typescript.nvim")
packadd("vCoolor.vim")
packadd("vim-abolish")

packadd("numToStr/Comment.nvim", function()
	require("Comment").setup({
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
	})
end)

packadd("vim-devicons")
packadd("vim-elixir")
packadd("vim-eunuch")
packadd("vim-fish")
packadd("vim-fugitive")
packadd("vim-gnupg")
packadd("vim-jsonnet")
packadd("pest-parser/pest.vim")
packadd("vim-racket")
packadd("vim-repeat")
packadd("vim-rhubarb")
packadd("vim-rsi")

packadd("vim-sandwich", function()
	vim.cmd([[runtime macros/sandwich/keymap/surround.vim]])

	local t = vim.deepcopy(vim.g["sandwich#default_recipes"])

	table.insert(t, {
		buns = { "<%=", "%>" },
		input = { "=" },
	})

	table.insert(t, {
		buns = { "<%", "%>" },
		input = { "-" },
	})

	vim.g["sandwich#recipes"] = t
end)

packadd("vim-scriptease")
packadd("vim-sleuth")
packadd("vim-speeddating")
packadd("vim-syntax-vcl")
packadd("vim-unimpaired")
packadd("vim-varnish")
packadd("vim-vinegar")

packadd("vim-visual-multi", function()
	map("n", "<C-LeftMouse>", "<Plug>(VM-Mouse-Cursor)")
	map("n", "<C-RightMouse>", "<Plug>(VM-Mouse-Word)")
	map("n", "<M-C-RightMouse>", "<Plug>(VM-Mouse-Column)")
	map("n", "<c-s-j>", "<Plug>(VM-Add-Cursor-Down)")
	map("n", "<c-s-k>", "<Plug>(VM-Add-Cursor-Up)")
end)

packadd("vim-wipeout")
packadd("which-key.nvim")
packadd("zen-mode.nvim")
packadd("folke/neodev.nvim")

packadd("colortils.nvim", function()
	require("colortils").setup({
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
	})
end)

safe_require("neotest", function(m)
	m.setup({
		adapters = {
			require("neotest-plenary"),
			require("neotest-elixir"),
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
end)

-- simrat39/symbols-outline.nvim
safe_require("symbols-outline", L("|m| m.setup()"))

-- folke/zen-mode.nvim
-- folke/twighlight.nvim
do
	local zen_mode = require("zen-mode")
	local twilight = require("twilight")
	local opts = { dimming = { alpha = 0.4 } }
	zen_mode.setup(opts)
	twilight.setup(opts)
end

-- Treesitter
do
	local config = require("nvim-treesitter.configs")

	local setup = config["setup"]

	local parser_config = require("nvim-treesitter.parsers"):get_parser_configs()

	setup({
		ensure_installed = {},
		-- treeclimber = { enable = true },
		query_linter = { enable = true, use_virtual_text = true, lint_events = { "BufWrite", "CursorHold" } },
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
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = t("<leader>v"),
				node_incremental = "<M-n>",
				scope_incremental = "<M-N>",
				node_decremental = "<M-p>",
			},
		},
		indent = { enable = true },
		-- refactor = {
		-- 	highlight_definitions = { enable = true },
		-- 	highlight_current_scope = { enable = false },
		-- 	smart_rename = { enable = true, keymaps = { smart_rename = "<leader>rr" } },
		-- },
		highlight = {
			enable = true,
			custom_captures = {},
		},
		rainbow = { enable = true, extended_mode = true, max_file_lines = nil },
	})
end

-- mg979/vim-visual-multi
vim.g.vm_theme = "paper"

-- lukas-reineke/indent-blankline.nvim
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_char_list = { "\226\148\131" }
vim.g.indent_blankline_filetype_exclude = { "help" }
vim.g.indent_blankline_char_list = { "|", "¦", "┆", "┊" }

require("indent_blankline").setup({
	show_current_context = true,
	show_current_context_start = false,
})

-- lewis6991/gitsigns.nvim
protected(function()
	local gitsigns = require("gitsigns")
	gitsigns.setup({
		watch_gitdir = { interval = 5000 },
		signs = {
			add = { hl = "GitSignsAdd", text = "\226\148\130", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
			change = {
				hl = "GitSignsChange",
				text = "\226\148\130",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
			delete = {
				hl = "GitSignsDelete",
				text = "_",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			topdelete = {
				hl = "GitSignsDelete",
				text = "\226\128\190",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			changedelete = {
				hl = "GitSignsChange",
				text = "~",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
		},
		on_attach = function()
			require("user/keymaps/gitsigns")
		end,
	})
end)

protected(function()
	require("octo").setup()
end)

protected(function()
	require("stabilize").setup()
end)

protected(function()
	require("mason").setup({})
	require("mason-lspconfig").setup({})
end)

protected(function()
	require("ssr").setup({
		min_width = 50,
		min_height = 5,
		keymaps = {
			close = "q",
			next_match = "n",
			prev_match = "N",
			replace_all = "<leader><cr>",
		},
	})
end)

vim.o.rtp = vim.o.rtp .. ",/home/dylan/.config/nvim/pack/plugins/start/vim-fugitive/"

safe_require("trouble", L("|m| m.setup()"))
safe_require("user/boxes")
safe_require("user/lsp")
safe_require("user/colors", L("|m| m.init()"))
safe_require("user/background", L("|m| m.init()"))
safe_require("user/statusline", L("|m| m.setup()"))
safe_require("user/keymaps", L("|m| m.setup()"))
safe_require("user/boxes")
safe_require("user/filetypes")
safe_require("user/commands")
safe_require("user/projects")
safe_require("user/search_and_replace")
safe_require("user/jest")

packadd("nvim-kitty", function()
	local mod = require("nvim-kitty")
	mod.setup({})
	map("n", "<leader>pq", mod.finder)
end)

safe_require("nvim-treeclimber", function()
	local mod = require("nvim-treeclimber")

	mod.setup({})

	vim.keymap.set({ "n", "x", "o" }, "<M-n>", mod.select_grow_forward, { desc = "Add the next node to the selection" })

	vim.keymap.set(
		{ "n", "x", "o" },
		"<M-p>",
		mod.select_grow_backward,
		{ desc = "Add the previous node to the selection" }
	)
end)

vim.o.exrc = true
vim.o.secure = true
