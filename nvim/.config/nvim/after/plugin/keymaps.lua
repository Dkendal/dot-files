local map = vim.keymap.set
local which_key = require("which-key")
local ts = require("telescope.builtin")
local register = which_key.register
local ls = require("luasnip")

-------------------------------------------------------------------------------
-- Functions                                                                 --
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Keymaps                                                                   --
-------------------------------------------------------------------------------

-- local function get_visual_selection()
-- 	local start = table.unpack(vim.api.nvim_buf_get_mark(0, "<"))
-- 	local end_ = table.unpack(vim.api.nvim_buf_get_mark(0, ">"))
-- 	return vim.api.nvim_buf_get_lines(0, start - 1, end_, false)
-- end

-- general.setup({
-- 	use_whichkey = true,
-- })

-- general.map({
-- 	filetype = "lua",
-- 	maps = {
-- 		{
-- 			mode = "v",
-- 			label = "Eval range",
-- 			lhs = "<leader>ee",
-- 			rhs = {
-- 				"<esc>",
-- 				function()
-- 					local code = table.concat(get_visual_selection(), "\n")
-- 					local f = loadstring(code)
-- 					f()
-- 				end,
-- 			},
-- 		},
-- 	},
-- })

-- general.map({
-- 	filetype = "lua",
-- 	label = "Markdown preview",
-- 	mode = "n",
-- 	lhs = "<leader>mp",
-- 	rhs = "<cmd>term glow %<>",
-- })

-- map("n", "<M-J>", function()
-- 	tc.next()
-- end, {})

-- map("n", "<M-j>", function()
-- 	tc.next_named()
-- end, {})

-- map("n", "<M-k>", function()
-- 	tc.prev_named()
-- end, {})

map("", "[[", "?{<CR>w99[{")
map("", "[]", "k$][%?}<CR>")
map("", "][", "/}<CR>b99]}")
map("", "]]", "j0[[%/{<CR>")
map("c", "<C-a>", "<Home>")
map("c", "<C-b>", "<Left>")
map("c", "<C-e>", "<End>")
map("c", "<C-f>", "<Right>")
map("c", "<C-n>", "<Down>")
map("c", "<C-p>", "<Up>")
map("c", "<M-b>", "<S-Left>")
map("c", "<M-f>", "<S-Right>")
map("n", "-", ":Explore<cr>")
map("n", "<down>", "<c-w>-")
map("n", "<expr>", "<leader>* '<cmd>Rg!<space>'.expand('<cword>').'<cr>'")
map("n", "<leader>/", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>;", ":Commentary<CR>")
map("n", "<leader>ay", ":let @+='[[' . expand('%:~') . '::' . line('.') . ']]'<cr>:let @*=@+<cr>:echo @*<cr>")
map("n", "<leader>bb", ":ViperBuffers<cr>")
map("n", "<leader>bd", ":bp<cr>:bd #<cr>")
map("n", "<leader>e", ":e <c-r>=expand('%:h')<cr>")
map("n", "<leader>feR", ":Runtime<cr>")
map("n", "<leader>fed", "~/.config/nvim/fnl/config.fnl<cr>")
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>")
map("n", "<leader>fyl", ":let @+=expand('%') . ':' . line('.')<cr>:let @*=@+<cr>")
map("n", "<leader>fyp", ":let @+=expand('%:p')<cr>:let @*=@+<cr>")
map("n", "<leader>fyt", ":let @+=expand('%:t')<cr>:let @*=@+<cr>")
map("n", "<leader>fyy", ":let @+=expand('%')<cr>:let @*=@+<cr>")
map("n", "<leader>fy~", ":let @+=expand('%:~')<cr>:let @*=@+<cr>")
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>")
map("n", "<leader>gla", "<cmd>Telescope git_commits<cr>")
map("n", "<leader>glb", "<cmd>Telescope git_bcommits<cr>")
map("n", "<leader>o", "<cmd>SymbolsOutline<cr>")
map("n", "<leader>pm", ":Marks<cr>")
map("n", "<leader>tF", ":ZenMode<cr>")
map("n", "<leader>tb", ":lua require('background').toggle()<cr>")
map("n", "<leader>tf", ":Twilight<cr>")
map("n", "<leader>w", "<c-w>")
map("n", "<leader>wd", ":q<cr>")
map("n", "<leader>wn", ":tabe<cr>")
map("n", "<leader>ww", ":Windows<cr>")
map("n", "<leader>zF", "zMzv")
map("n", "<left>", "<c-w>=")
map("n", "<space>q", "<cmd>TroubleToggle document_diagnostics<CR>")
map("n", "<space>q", "<cmd>TroubleToggle workspace_diagnostics<CR>")
map("n", "<up>", "<c-w>+")
map("o", "<leader>;", ":Commentary<CR>")
map("t", "<c-[>", "<c-\\><c-n>")
map("v", "<", "<gv")
map("v", "<leader>/", ":y:<C-u>:ViperGrep rg --vimgrep -w -- <C-r>0<CR>")
map("v", "<leader>;", ":Commentary<CR>")
map("v", ">", ">gv")
map("x", "@@", ":normal@@<cr>")

map({ "i", "s" }, "<c-j>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

map({ "i", "s" }, "<c-k>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

map("i", "<c-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

map("i", "<c-u>", require("luasnip.extras.select_choice"))

map("i", "<c-.>", vim.lsp.codelens.display)

register({
	-- Context aware folding
	["<tab>"] = {
		function()
			vim.wo.foldenable = true

			if vim.fn.foldlevel(".") <= 0 then
				vim.api.nvim_feedkeys("zr", "nt", false)
			else
				vim.api.nvim_feedkeys("zo", "nt", false)
			end
		end,
		"Fold more",
	},
	-- Context aware folding
	["<s-tab>"] = {
		function()
			vim.wo.foldenable = true
			if vim.fn.foldlevel(".") <= 0 then
				vim.api.nvim_feedkeys("zm", "nt", false)
			else
				vim.api.nvim_feedkeys("zc", "nt", false)
			end
		end,
		"Fold less",
	},
})

register({
	["<leader>"] = { "<cmd>Telescope commands<cr>" },
	ee = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", "Get diagnostic" },
	ef = {
		function()
			vim.lsp.buf.formatting_seq_sync()
		end,
		"Format file",
	},
	f = {
		name = "Files",
		e = {
			name = "Config files",
			d = { "<cmd>e ~/.config/nvim/init.lua<cr>", "Open init.lua" },
			c = { "<cmd>PackerCompile<cr>", "Packer compile" },
			R = { "<cmd>lua reload 'init'<cr>", "Reload init.lua" },
			s = { "<cmd>luafile ~/.config/nvim/after/plugin/snippets.lua<cr>", "Reload snippets" },
			m = { "<cmd>luafile ~/.config/nvim/after/plugin/keymaps.lua<cr>", "Reload keymaps" },
			e = { "<cmd>e .envrc<cr>", "Open envrc" },
			E = { "<cmd>e .tool-versions<cr>", "Open tool-versions" },
			r = { "<cmd>Telescope reloader<cr>", "Reloader" },
			["/"] = {
				function()
					return ts.live_grep({ cwd = vim.fn.stdpath("config") })
				end,
				"Search Vim config",
			},
			["?"] = {
				function()
					return ts.live_grep({ cwd = vim.fn.stdpath("data") })
				end,
				"Search Vim data",
			},
			l = {
				function()
					return ts.find_files({ cwd = vim.fn.stdpath("config") })
				end,
				"Vim config files",
			},
			L = {
				function()
					return ts.find_files({ cwd = vim.fn.stdpath("data") })
				end,
				"Vim data files",
			},
			p = {
				name = "Packer",
				i = { "<cmd>PackerInstall<cr>", "Packer install" },
				s = { "<cmd>PackerStatus<cr>", "Packer status" },
				C = { "<cmd>PackerClean<cr>", "Packer clean" },
				c = { "<cmd>PackerCompile<cr>", "Packer compile" },
			},
		},
		f = {
			function()
				return ts.find_files({ find_command = { "fd" } })
			end,
			"Find files",
		},
		F = {
			function()
				return ts.find_files({ find_command = { "fd", "-u" } })
			end,
			"Find files w/ hidden",
		},
	},
	g = {
		D = { "<cmd>Gvdiffsplit!<cr>", "3-way diff" },
		s = { "<cmd>G<cr>", "Git status" },
	},
	s = { s = {
		function()
			return ts.current_buffer_fuzzy_find()
		end,
		"Search current buffer",
	} },
	p = {
		r = { ":ViperRegisters<cr>", "Registers" },
		f = {
			function()
				return ts.git_files()
			end,
			"Git files",
		},
		g = { ":Telescope git_status<cr>", "Git status" },
	},
	h = {
		name = "Vim",
		h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
		m = { "<cmd>Telescope man_pages<cr>", "Help tags" },
		d = {
			name = "Describe",
			f = { "<cmd>P! function<cr>", "Functions" },
			v = { "<cmd>P! verbose let<cr>", "Variables" },
			m = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		},
	},
	l = {
		name = "LSP",
		a = { "<cmd>Telescope lsp_code_actions<cr>", "Code action" },
		d = {
			name = "Document",
			s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
		},
		w = {
			name = "Workspace",
			d = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Diagnostics" },
			s = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Diagnostics" },
		},
		R = { "<cmd>LspRestart<cr>", "Restart" },
		I = { "<cmd>LspInfo<cr>", "Info" },
		s = { "<cmd>LspStart<cr>", "Start" },
		S = { "<cmd>LspStart<cr>", "Stop" },
	},
	t = {
		name = "Test",
		l = { "<CMD>UltestLast<CR>", "Last" },
		f = { "<CMD>Ultest<CR>", "File" },
		t = { "<CMD>UltestNearest<CR>", "Nearest" },
		o = { "<CMD>UltestOutput<CR>", "Output" },
		a = { "<CMD>UltestAttach<CR>", "Attach" },
		s = { "<CMD>UltestSummary<CR>", "Summary" },
		S = { "<CMD>UltestStop<CR>", "Stop" },
		c = { "<CMD>UltestClear<CR>", "Clear" },
	},
}, { prefix = "<leader>" })

for _, key in ipairs({ "b", "c", "d", "h", "i", "l", "n", "r", "s", "u", "v", "w", "x" }) do
	map("n", ("<leader>T" .. key), ("yo" .. key))
end

