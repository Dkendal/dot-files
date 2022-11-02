local which_key = require("which-key")
local ts = require("telescope.builtin")
local Hydra = require("hydra")
local ls = require("luasnip")

local map = vim.keymap.set
local register = which_key.register
local autocmd = vim.api.nvim_create_autocmd
local fn = vim.fn

vim.cmd([[runtime macros/sandwich/keymap/surround.vim]])

local function t(str)
	return vim.api.nvim_replace_termcodes(str, true, false, true)
end

local function feedkeys(keys)
	vim.api.nvim_feedkeys(t(keys), "n", false)
end

local function glob2re(glob)
	local s = glob
	s = string.gsub(s, "*", "(.+)")
	s = string.gsub(s, "{(.-)}", function(str)
		return "(" .. string.gsub(str, ",", "|") .. ")"
	end)
	return s
end

local function glob2capture(glob)
	local idx = 0
	local s = glob

	local function ref()
		idx = idx + 1
		return "%" .. idx
	end

	s = string.gsub(glob, "*", ref)
	s = string.gsub(s, "{(.-)}", ref)
	s = string.gsub(s, "%[(.-)%]", ref)

	return s
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

-------------------------------------------------------------------------------
-- Readline like bindings                                                    --
-------------------------------------------------------------------------------
map("c", "<C-a>", "<Home>")
map("c", "<C-b>", "<Left>")
map("c", "<C-e>", "<End>")
map("c", "<C-f>", "<Right>")
map("c", "<C-n>", "<Down>")
map("c", "<C-p>", "<Up>")
map("c", "<M-b>", "<S-Left>")
map("c", "<M-f>", "<S-Right>")
map("c", "<C-BS>", "<c-w>")

map("i", "<C-h>", vim.lsp.buf.signature_help)

map("n", "-", vim.cmd.Explore)

map("n", "<C-s>", ":s/<c-r><c-w>//gc<left><left><left>")
map("n", "<c-.>", vim.lsp.buf.code_action)
map("n", "<c-\\>", function()
	vim.lsp.buf.format({ async = true })
end)
map("n", "<c-s-o>", "<cmd>Telescope lsp_document_symbols<cr>")
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
map("n", "<m-o>", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>")
map("n", "gr", "<cmd>TroubleToggle lsp_references<CR>")
map("v", "<C-s>", ":s/")

-- Copy path to clipboard
map("n", "<leader>fyy", function()
	local path = vim.fn.expand("%:~")
	vim.fn.setreg("@", path)
	vim.fn.setreg("*", path)
	vim.notify(path)
end)

-- map("n", "<leader>fy~", function ()
-- 	local path = vim.fn.expand("%:~:.")
-- 	vim.fn.setreg("@", path)
-- 	vim.fn.setreg("*", path)
-- 	vim.notify(path)
-- end)

map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>")
map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>")
map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>")
map("n", "<leader>hS", "<cmd>Gitsigns preview_hunk<cr>")
map("n", "<leader>gla", "<cmd>Telescope git_commits<cr>")
map("n", "<leader>glb", "<cmd>Telescope git_bcommits<cr>")
map("n", "<leader>o", "<cmd>SymbolsOutline<cr>")
map("n", "<leader>pm", ":Marks<cr>")
map("n", "<leader>pq", ":KittyPaths<cr>")
map("n", "<leader>pp", ":ProjectOpen<cr>")
map("n", "<leader>tF", ":ZenMode<cr>")
map("n", "<leader>tb", ":lua require('user/background').toggle()<cr>", { silent = true })
map("n", "<leader>tf", ":Twilight<cr>")
map("n", "<leader>w", "<c-w>")
map("n", "<leader>wd", vim.cmd.q)
map("n", "<leader>wn", vim.cmd.tabe)
map("n", "<leader>ww", vim.cmd.Windows)
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
map("n", "[c", "<cmd>Gitsigns prev_hunk<cr>")
map("n", "]c", "<cmd>Gitsigns next_hunk<cr>")
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gO", vim.lsp.buf.document_symbol)
map("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
map("n", "gi", vim.lsp.buf.implementation)
map("n", "zR", require("ufo").openAllFolds)
map("n", "zM", require("ufo").closeAllFolds)
map("o", "<leader>;", ":Commentary<CR>")
-------------------------------------------------------------------------------
-- Terminal Mode                                                             --
-------------------------------------------------------------------------------
map("t", "<c-[>", "<c-\\><c-n>")
-------------------------------------------------------------------------------
-- Visual Mode                                                               --
-------------------------------------------------------------------------------
map("v", "<", "<gv")
map("v", "<c-.>", vim.lsp.buf.range_code_action)
map("v", "<leader>;", ":Commentary<CR>")
map("v", ">", ">gv")

---@return string[]
local function get_selected_text()
	local _, start_row, start_col, _ = unpack(vim.fn.getpos("v"))
	local _, end_row, end_col, _ = unpack(vim.fn.getpos("."))

	if start_row > end_row or (start_row == end_row and start_col > end_col) then
		-- Swap start and end
		start_row, start_col, end_row, end_col = end_row, end_col, start_row, start_col
	end

	start_row = start_row - 1
	start_col = start_col - 1
	end_row = end_row - 1

	if vim.api.nvim_get_mode().mode == "V" then
		start_col = 0
		end_col = -1
	end

	return vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
end

local function set_normal_mode()
	feedkeys("<esc>")
end

-- Search for visually selected text
map("v", "*", function()
	local lines = get_selected_text()
	local text = vim.tbl_map(function(line)
		return vim.fn.escape(line, "\\/")
	end, lines)
	text = table.concat(text, "\\n")
	text = text:gsub(t("<tab>"), "\\t")
	text = text:gsub("%s+", "\\s\\+")
	vim.fn.setreg("/", "\\V" .. text)
	set_normal_mode()
	feedkeys("//")
end)

-- Search and replace visually selected text
map("v", "<leader>s", function()
	local lines = get_selected_text()
	local text = vim.tbl_map(function(line)
		return vim.fn.escape(line, "\\/")
	end, lines)
	text = table.concat(text, "\\n")
	text = text:gsub(t("<tab>"), "\\t")
	vim.fn.setreg("/", "\\V" .. text)
	vim.fn.setreg("0", table.concat(lines, "\n"))
	set_normal_mode()
	feedkeys(":s///g<left><left>")
end)

map("v", "<leader>S", function()
	local lines = get_selected_text()
	local text = vim.tbl_map(function(line)
		return vim.fn.escape(line, "\\/")
	end, lines)
	text = table.concat(text, "\\n")
	text = text:gsub(t("<tab>"), "\\t")
	vim.fn.setreg("/", "\\V" .. text)
	vim.fn.setreg("0", table.concat(lines, "\n"))
	set_normal_mode()
	feedkeys(":%s///gc<left><left><left>")
end)

map("x", "@@", ":normal@@<cr>")

map("n", "<space>Wl", function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end)

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
		-- f = { function () require("neotest").run.run(vim.fn.expand("%:.")) end, "File" },
		-- t = { function () require("neotest").run.run() end, "Nearest" },
		-- o = { function () require("neotest").output.open() end, "Output" },
		-- a = { function () require("neotest").run.attach() end, "Attach" },
		-- s = { function () require("neotest").summary.toggle() end, "Summary" },
		-- S = { function () require("neotest").run.stop() end, "Stop" },
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

local function altPair(globA, globB)
	keymap({
		pattern = { globA },
		callback = function(args)
			mapAlternate(args.file, glob2re(globA), glob2capture(globB))
		end,
	})

	keymap({
		pattern = { globB },
		callback = function(args)
			mapAlternate(args.file, glob2re(globB), glob2capture(globA))
		end,
	})
end

keymap({
	pattern = { "*_spec.lua" },
	callback = function(args)
		map("n", "<leader>tt", "<plug>PlenaryTestFile", {})
	end,
})

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

-- Racket
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

-- Haskell
altPair("src/*.hs", "test/*Spec.hs")
