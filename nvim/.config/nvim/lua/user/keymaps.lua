local M = {}
local map = vim.keymap.set
local which_key = require("which-key")
local ts = require("telescope.builtin")
local register = which_key.register
local ls = require("luasnip")
local autocmd = vim.api.nvim_create_autocmd
local fn = vim.fn

-- Fix false friends keyboard inputs
-- https://github.com/neovim/neovim/issues/17867
if vim.env.TERM == "xterm-kitty" then
	autocmd({"UIEnter"}, {
		pattern = "*",
		callback = function ()
			if vim.v.event.chan == 0 then
				vim.fn.chansend(vim.v.stderr, "\x1b[>1u")
			end
		end
	})
	autocmd({"UILeave"}, {
		pattern = "*",
		callback = function ()
			if vim.v.event.chan == 0 then
				vim.fn.chansend(vim.v.stderr, "\x1b[<1u")
			end
		end
	})
end

local function feedkeys(keys)
	local key = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(key, "n", false)
end

local function globToRegex(glob)
	return string.gsub(glob, "*", "(.+)")
end

local function globToCapture(glob)
	local idx = 0
	return string.gsub(glob, "*", function()
		idx = idx + 1
		return "%" .. idx
	end)
end

local function mapAlternate(file, pattern, substitute)
	file = vim.fn.fnamemodify(file, ":~:.")

	local alt = string.gsub(file, pattern, substitute)

	local function printAlt()
		print(alt)
	end

	local function open()
		vim.cmd(string.format("e %s", alt))
	end

	vim.api.nvim_buf_create_user_command(0, "PrintAlt", printAlt, { force = true })
	map("n", "<leader>pa", open, { buffer = true })
end

-- Readline like bindings

map("c", "<C-a>", "<Home>")
map("c", "<C-b>", "<Left>")
map("c", "<C-e>", "<End>")
map("c", "<C-f>", "<Right>")
map("c", "<C-n>", "<Down>")
map("c", "<C-p>", "<Up>")
map("c", "<M-b>", "<S-Left>")
map("c", "<M-f>", "<S-Right>")
map("c", "<C-BS>", "<c-w>")

-- Window height
-- map("n", "<down>", "<c-w>-")
-- map("n", "<up>", "<c-w>+")

map("i", "<C-h>", vim.lsp.buf.signature_help)
map("n", "-", ":Explore<cr>")
map("n", "<c-.>", vim.lsp.buf.code_action)
map("n", "<c-\\>", vim.lsp.buf.format)
map("n", "<c-s-o>", "<cmd>Telescope lsp_document_symbols<cr>")
map("n", "<m-o>", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>")
map("n", "<expr>", "<leader>* '<cmd>Rg!<space>'.expand('<cword>').'<cr>'")
map("n", "<leader>/", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>;", ":Commentary<CR>")
map("n", "<leader><space>", "<cmd>Telescope commands<cr>")
map("n", "<leader>ay", ":let @+='[[' . expand('%:~') . '::' . line('.') . ']]'<cr>:let @*=@+<cr>:echo @*<cr>")
map("n", "<leader>bb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>bd", ":bp<cr>:bd #<cr>")
map("n", "<leader>e", ":e <c-r>=expand('%:h')<cr>")
map("n", "<leader>feR", ":source<cr>")
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
map("n", "<space>D", vim.lsp.buf.type_definition)
map("n", "<space>Wa", vim.lsp.buf.add_workspace_folder)
map("n", "<space>Wr", vim.lsp.buf.remove_workspace_folder)
map("n", "<space>ee", ":lua vim.diagnostic.open_float()<cr>", { silent = true })
map("n", "<space>q", "<cmd>TroubleToggle document_diagnostics<CR>")
map("n", "<space>q", "<cmd>TroubleToggle workspace_diagnostics<CR>")
map("n", "<space>rn", vim.lsp.buf.rename)
map("n", "K", vim.lsp.buf.hover)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "gD", vim.lsp.buf.declaration)
map("n", "gO", vim.lsp.buf.document_symbol)
map("n", "gd", vim.lsp.buf.definition)
map("n", "gi", vim.lsp.buf.implementation)
map("o", "<leader>;", ":Commentary<CR>")
map("t", "<c-[>", "<c-\\><c-n>")
map("v", "<", "<gv")
map("v", "<c-.>", vim.lsp.buf.range_code_action)
map("v", "<leader>;", ":Commentary<CR>")
map("v", ">", ">gv")
map("x", "@@", ":normal@@<cr>")

map("n", "<space>Wl", function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, opts)

map("n", "gr", "<cmd>TroubleToggle lsp_references<CR>", opts)

-- remap to open the Telescope refactoring menu in visual mode
map("v", "<leader>rr", function()
	feedkeys("<esc>")
	require("telescope").extensions.refactoring.refactors()
end, { noremap = true })

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

-- -- -- Context aware folding
-- map("n", "<Tab>", function()
-- 	vim.wo.foldenable = true

-- 	if fn.foldlevel(".") <= 0 then
-- 		feedkeys("zr")
-- 	else
-- 		feedkeys("zo")
-- 	end
-- end)
-- -- -- Context aware folding
-- map("n", "<S-Tab>", function()
-- 	vim.wo.foldenable = true
-- 	if fn.foldlevel(".") <= 0 then
-- 		feedkeys("zm")
-- 	else
-- 		feedkeys("zc")
-- 	end
-- end)

-- Normal <leader>
register({
	["<s-c-o>"] = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
	f = {
		name = "Files",
		e = {
			name = "Config files",
			d = { "<cmd>e ~/.config/nvim/init.lua<cr>", "Open init.lua" },
			c = { "<cmd>PackerCompile<cr>", "Packer compile" },
			s = { "<cmd>luafile ~/.config/nvim/after/plugin/snippets.lua<cr>", "Reload snippets" },
			m = { "<cmd>luafile ~/.config/nvim/after/plugin/keymaps.lua<cr>", "Reload keymaps" },
			e = { "<cmd>e .envrc<cr>", "Open envrc" },
			E = { "<cmd>e .tool-versions<cr>", "Open tool-versions" },
			r = { "<cmd>Telescope reloader<cr>", "Reloader" },
			["/"] = {
				function()
					return ts.live_grep({ cwd = fn.stdpath("config") })
				end,
				"Search Vim config",
			},
			["?"] = {
				function()
					return ts.live_grep({ cwd = fn.stdpath("data") })
				end,
				"Search Vim data",
			},
			l = {
				function()
					return ts.find_files({ cwd = fn.stdpath("config") })
				end,
				"Vim config files",
			},
			L = {
				function()
					return ts.find_files({ cwd = fn.stdpath("data") })
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

local group = vim.api.nvim_create_augroup("UserKeymaps", { clear = true })

local function keymap(opts)
	local events = opts.events or { "BufEnter", "BufWinEnter" }

	autocmd(events, {
		group = group,
		pattern = opts.pattern,
		callback = opts.callback,
	})
end

keymap({
	pattern = { "*.lua" },
	callback = function(args)
		map("n", "<leader>mr", function()
			local file = args.file

			if file:match("/?lua/") then
				local module_name = file:gsub(".*/?lua/(.*)%.lua$", "%1"):gsub("/", ".")

				if module_name ~= "" then
					print("reloaded module", module_name)
					reload(module_name)
				end
			else
				print("reloaded file", file)
				vim.cmd([[source %]])
			end
		end, { silent = true, buffer = true })
	end,
})

-- Typescript / Javascript
keymap({
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function(args)
		mapAlternate(args.file, "(.+).([jt]sx?)", "%1.test.%2")
	end,
})

keymap({
	pattern = { "*.test.ts", "*.test.tsx", "*.js", "*.jsx" },
	callback = function(args)
		mapAlternate(args.file, "(.+).test.([jt]sx?)", "%1.%2")
	end,
})

-- Lua
keymap({
	pattern = { "*.rkt" },
	callback = function(args)
		mapAlternate(args.file, "(.+).rkt", "%1-test.rkt")
	end,
})

keymap({
	pattern = { "*-test.rkt" },
	callback = function(args)
		mapAlternate(args.file, "(.+)-test.rkt", "%1.rkt")
	end,
})

-- Lua
keymap({
	pattern = { "src/*.hs" },
	callback = function(args)
		mapAlternate(args.file, globToRegex("src/*.hs"), globToCapture("test/Spec/*.hs"))
	end,
})

keymap({
	pattern = { "test/Spec/*.hs" },
	callback = function(args)
		mapAlternate(args.file, globToRegex("test/Spec/*.hs"), globToCapture("src/*.hs"))
	end,
})
