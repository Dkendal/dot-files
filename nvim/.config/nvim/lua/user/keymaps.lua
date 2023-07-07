local M = {}

local which_key = require("which-key")
local ts = require("telescope.builtin")
local Hydra = require("hydra")
local ls = require("luasnip")
local gitsigns = require("gitsigns")
local util = require("user.util")

local map = util.map
local apply = util.apply
local feedkeys = util.feedkeys
local t = util.t
local set_normal_mode = util.set_normal_mode

local register = which_key.register
local autocmd = vim.api.nvim_create_autocmd
local fn = vim.fn

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

local function map_alternate(file, pattern, substitute)
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

local function format_async()
	vim.lsp.buf.format({ async = true })
end

local function set_clipboard(text)
	vim.fn.setreg("+", text)
	vim.fn.setreg("*", text)
end

local function copy_absolute_path()
	local path = vim.fn.expand("%:~")
	set_clipboard(path)
	vim.notify(path)
end

local function copy_relative_path()
	local path = vim.fn.expand("%")
	vim.fn.setreg("+", path)
	vim.fn.setreg("*", path)
	vim.notify(path)
end

local function telescope_refactors()
	feedkeys("<esc>")
	require("telescope").extensions.refactoring.refactors()
end

local function inspect_workspace_folders()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end

local function find_config_files()
	return ts.find_files({ search_dirs = { fn.stdpath("config") } })
end

local function find_data_files()
	return ts.find_files({ search_dirs = fn.stdpath("data") })
end

local function grep_data_files()
	return ts.live_grep({ cwd = fn.stdpath("data") })
end

local function find_hidden_files()
	return ts.find_files({ find_command = { "fd", "-u" } })
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
			map_alternate(args.file, glob2re(globA), glob2capture(globB))
		end,
	})

	keymap({
		pattern = { globB },
		callback = function(args)
			map_alternate(args.file, glob2re(globB), glob2capture(globA))
		end,
	})
end

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

function M.setup()
	-- Fix terms
	for _, key in ipairs({ "<c-i>", "<c-j>", "<c-h>", "<c-m>" }) do
		map("n", key, key, { noremap = true })
	end

	-- Neotest
	do
		local neotest = require("neotest")

		map("n", "<leader>tt", function()
			neotest.run.run()
		end, { desc = "Nearest test" })

		map("n", "<leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Test file" })

		map("n", "<leader>tS", function()
			neotest.run.stop()
		end, { desc = "Stop test" })

		map("n", "<leader>ts", function()
			neotest.summary.toggle()
		end, { desc = "Summary" })

		map("n", "<leader>to", function()
			neotest.output.open()
		end, { desc = "Open output" })

		map("n", "<leader>tO", function()
			neotest.output_panel.toggle()
		end, { desc = "Open output panel" })

		map("n", "<leader>td", function()
			neotest.diagnostic()
		end, { desc = "Open output panel" })

		map("n", "<leader>ta", function()
			neotest.run.attach()
		end, { desc = "Attach to test" })
	end

	-- Readline bindings
	do
		map("c", "<C-a>", "<Home>")
		map("c", "<C-b>", "<Left>")
		map("c", "<C-e>", "<End>")
		map("c", "<C-f>", "<Right>")
		map("c", "<C-n>", "<Down>")
		map("c", "<C-p>", "<Up>")
		map("c", "<M-b>", "<S-Left>")
		map("c", "<M-f>", "<S-Right>")
		map("c", "<C-BS>", "<c-w>")
	end

	map("i", "<C-h>", vim.lsp.buf.signature_help)

	map("n", "-", function()
		vim.cmd.Explore()
	end, { silent = true })

	map("n", "<C-s>", ":s/<c-r><c-w>//gc<left><left><left>")
	map("n", "<c-.>", vim.lsp.buf.code_action)
	map("n", "<c-\\>", format_async)
	map("n", "<leader>\\", format_async)
	map("n", "<c-s-o>", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
	map("n", "<m-o>", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace symbols" })
	map("n", "<expr>", "<leader>* '<cmd>Rg!<space>'.expand('<cword>').'<cr>'", { desc = "Rg word under cursor" })
	map("n", "<leader>/", "<cmd>Telescope live_grep<cr>")
	map("n", "<leader><space>", "<cmd>Telescope commands<cr>")
	map("n", "<leader>ay", ":let @+='[[' . expand('%:~') . '::' . line('.') . ']]'<cr>:let @*=@+<cr>:echo @*<cr>")
	map("n", "<leader>bb", "<cmd>Telescope buffers<cr>")
	map("n", "<leader>bd", ":bp<cr>:bd #<cr>")
	map("n", "<leader>e", ":e <c-r>=expand('%:h')<cr>")
	map("n", "<leader>feR", ":source<cr>")
	map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>")
	map("n", "gr", "<cmd>TroubleToggle lsp_references<CR>")
	map("v", "<C-s>", ":s/")

	-- Copy relative path to clipboard
	map("n", "<leader>fyy", copy_relative_path)
	-- Copy absolute path to clipboard
	map("n", "<leader>fyY", copy_absolute_path)
	-- Copy path with line number
	map("n", "<leader>fyl", ":let @+=expand('%') . ':' . line('.')<cr>:let @*=@+<cr>")
	-- Copy basename
	map("n", "<leader>fyb", ":let @+=expand('%:t')<cr>:let @*=@+<cr>")

	map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>")
	map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>")
	map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>")
	map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>")
	map("n", "<leader>gla", "<cmd>Telescope git_commits<cr>")
	map("n", "<leader>glb", "<cmd>Telescope git_bcommits<cr>")
	map("n", "<leader>o", "<cmd>SymbolsOutline<cr>")
	map("n", "<leader>pm", ":Marks<cr>")
	map("n", "<leader>pq", ":KittyPaths<cr>")
	map("n", "<leader>pp", ":ProjectOpen<cr>")
	-- map("n", "<leader>tF", ":ZenMode<cr>")
	-- map("n", "<leader>tf", ":Twilight<cr>")
	map("n", "<leader>tb", ":lua require('user/background').toggle()<cr>", { silent = true })
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

	local gitsigns_opts = { navigation_message = false }
	map("n", "[c", apply(gitsigns.prev_hunk, gitsigns_opts))
	map("n", "]c", apply(gitsigns.next_hunk, gitsigns_opts))

	map("n", "[d", vim.diagnostic.goto_prev)
	map("n", "]d", vim.diagnostic.goto_next)
	map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
	map("n", "gO", vim.lsp.buf.document_symbol)
	map("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
	map("n", "gi", vim.lsp.buf.implementation)
	map("n", "zR", require("ufo").openAllFolds)
	map("n", "zM", require("ufo").closeAllFolds)

	map("t", "<c-[>", "<c-\\><c-n>")

	map("v", "<", "<gv")
	map("v", "<c-.>", vim.lsp.buf.code_action)
	map("v", ">", ">gv")

	vim.keymap.set({ "n", "x" }, "<leader>sr", function()
		require("ssr").open()
	end)

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

	map("n", "<space>Wl", inspect_workspace_folders)

	-- remap to open the Telescope refactoring menu in visual mode
	map("v", "<leader>rr", telescope_refactors, { noremap = true })

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

	-- Folding
	map("n", "<Tab>", function()
		xpcall(function()
			-- If there is no fold at the cursor, fold less
			if vim.fn.foldlevel(".") == 0 then
				vim.cmd("normal! zr")
			else
				-- If the cursor is on a closed fold, open it
				vim.cmd("normal! zo")
			end
		end, function(err)
			vim.notify(err, vim.log.levels.ERROR)
		end)
	end, { desc = "Unfold" })

	map("n", "<S-Tab>", function()
		xpcall(function()
			-- If there is no fold at the cursor, fold more
			if vim.fn.foldlevel(".") == 0 then
				vim.cmd("normal! zm")
			else
				-- If the cursor is on an open fold, close it
				vim.cmd("normal! zc")
			end
		end, function(err)
			vim.notify(err, vim.log.levels.ERROR)
		end)
	end, { desc = "Fold" })

	-- Normal <leader>
	map("n", "<leader>fed", ":e ~/.config/nvim/init.lua<cr>", { desc = "Edit init.lua" })
	map("n", "<leader>fes", ":e ~/.config/nvim/after/plugin/snippets.lua<cr>", { desc = "Edit snippets" })
	map("n", "<leader>fem", ":e ~/.config/nvim/after/plugin/keymaps.lua<cr>", { desc = "Edit keymaps" })
	map("n", "<leader>fee", ":e .envrc<cr>", { desc = "Edit envrc" })
	map("n", "<leader>feE", ":e .tool-versions<cr>", { desc = "Edit tool-versions" })
	map("n", "<leader>fer", ":Telescope reloader<cr>", { desc = "Reload config" })
	map("n", "<leader>fel", find_config_files, { desc = "Vim config files" })
	map("n", "<leader>feL", find_data_files, { desc = "Data config files" })
	map("n", "<leader>feL", grep_data_files, { desc = "Search Vim data" })
	map("n", "<leader>ff", apply(ts.find_files, { find_command = { "fd" } }), { desc = "Find files" })
	map("n", "<leader>fF", find_hidden_files, { desc = "Find files w/ hidden" })
	map("n", "<leader>pf", ts.git_files, { desc = "Git files" })
	map("n", "<leader>ps", ts.git_status, { desc = "Git Status" })
	map("n", "<M-O>", "<cmd>Telescope jumplist<cr>", { desc = "Jumplist" })

	register({
		g = {
			D = { "<cmd>Gvdiffsplit!<cr>", "3-way diff" },
			s = { "<cmd>G<cr>", "Git status" },
		},
		s = {
			s = {
				function()
					return ts.current_buffer_fuzzy_find()
				end,
				"Search current buffer",
			},
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
	}, { prefix = "<leader>" })

	-- Toggle keymaps
	for _, key in ipairs({ "b", "c", "d", "h", "i", "l", "n", "r", "s", "u", "v", "w", "x" }) do
		map("n", ("<leader>T" .. key), ("yo" .. key))
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
			map_alternate(args.file, "(.+).([jt]sx?)", "%1.test.%2")
		end,
	})

	keymap({
		pattern = { "*.test.ts", "*.test.tsx", "*.js", "*.jsx" },
		callback = function(args)
			map_alternate(args.file, "(.+).test.([jt]sx?)", "%1.%2")
		end,
	})

	-- Racket
	keymap({
		pattern = { "*.rkt" },
		callback = function(args)
			map_alternate(args.file, "(.+).rkt", "%1-test.rkt")
		end,
	})

	keymap({
		pattern = { "*-test.rkt" },
		callback = function(args)
			map_alternate(args.file, "(.+)-test.rkt", "%1.rkt")
		end,
	})

	-- Haskell
	altPair("src/*.hs", "test/*Spec.hs")

	-- Elixir
	altPair("lib/*.ex", "test/*_test.exs")

	altPair("lib/*/live/*.ex", "lib/*/live/*.html.heex")
end

return M
