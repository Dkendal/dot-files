local M = {}

local util = require("user.util")
local alternatives = require("user.alternatives")
local alternate_pair = alternatives.alternate_pair
local map_alternate = alternatives.map_alternate
local keymap = alternatives.keymap

local map = util.map
local apply = util.apply
local feedkeys = util.feedkeys
local t = util.t
local set_normal_mode = util.set_normal_mode

local autocmd = vim.api.nvim_create_autocmd
local fn = vim.fn

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
	return require("telescope.builtin").find_files({ search_dirs = { fn.stdpath("config") } })
end
local function find_files()
	require("telescope.builtin").find_files({ find_command = { "fd" } })
end

local function find_data_files()
	return require("telescope.builtin").find_files({ search_dirs = fn.stdpath("data") })
end

local function grep_data_files()
	return require("telescope.builtin").live_grep({ cwd = fn.stdpath("data") })
end

local function find_hidden_files()
	return require("telescope.builtin").find_files({ find_command = { "fd", "-u" } })
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

	map("i", "<C-h>", vim.lsp.buf.signature_help)

	map("n", "<C-s>", ":s/<c-r><c-w>//gc<left><left><left>")
	-- map("n", "<c-.>", vim.lsp.buf.code_action)
	map("n", "<c-\\>", format_async)
	map("n", "<leader>\\", format_async)
	map("n", "<expr>", "<leader>* '<cmd>Rg!<space>'.expand('<cword>').'<cr>'", { desc = "Rg word under cursor" })
	map("n", "<leader>ay", ":let @+='[[' . expand('%:~') . '::' . line('.') . ']]'<cr>:let @*=@+<cr>:echo @*<cr>")
	map("n", "<leader>bd", ":bp<cr>:bd #<cr>")
	map("n", "<leader>e", ":e <c-r>=expand('%:h')<cr>")
	map("n", "<leader>feR", ":source<cr>")
	map("n", "grr", vim.lsp.buf.references)
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
	-- map("n", "<leader>o", "<cmd>SymbolsOutline<cr>")
	map("n", "<leader>pm", ":Marks<cr>")
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
	-- map("n", "<space>q", "<cmd>TroubleToggle document_diagnostics<CR>")
	-- map("n", "<space>q", "<cmd>TroubleToggle workspace_diagnostics<CR>")
	map("n", "<space>rn", vim.lsp.buf.rename)
	map("n", "K", vim.lsp.buf.hover)

	map("n", "[c", function()
		require("gitsigns").nav_hunk("prev", { navigation_message = false })
	end)

	map("n", "]c", function()
		require("gitsigns").nav_hunk("next", { navigation_message = false })
	end)

	map("n", "[d", vim.diagnostic.goto_prev)
	map("n", "]d", vim.diagnostic.goto_next)
	map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
	map("n", "gO", vim.lsp.buf.document_symbol)
	map("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
	map("n", "gi", vim.lsp.buf.implementation)

	map("n", "zR", function()
		require("ufo").openAllFolds()
	end)

	map("n", "zM", function()
		require("ufo").closeAllFolds()
	end)

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
		local ls = require("luasnip")

		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end, { silent = true })

	map({ "i", "s" }, "<c-k>", function()
		local ls = require("luasnip")

		if ls.jumpable(-1) then
			ls.jump(-1)
		end
	end, { silent = true })

	map("i", "<c-l>", function()
		local ls = require("luasnip")

		if ls.choice_active() then
			ls.change_choice(1)
		end
	end)

	map("i", "<c-u>", function()
		require("luasnip.extras.select_choice")()
	end)

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

	map("n", "<leader>ff", find_files, { desc = "Find files" })

	map("n", "<leader>fF", find_hidden_files, { desc = "Find files w/ hidden" })
	map("n", "<leader>gD", "<cmd>Gvdiffsplit!<cr>", { desc = "3-way diff" })
	map("n", "<leader>gs", "<cmd>G<cr>", { desc = "Git status" })

	map("n", "<leader>hdf", "<cmd>P! function<cr>", { desc = "Describe: Functions" })
	map("n", "<leader>hdv", "<cmd>P! verbose let<cr>", { desc = "Describe: Variables" })

	map("n", "<leader>lR", "<cmd>LspRestart<cr>", { desc = "LSP: Restart" })
	map("n", "<leader>lI", "<cmd>LspInfo<cr>", { desc = "LSP: Info" })
	map("n", "<leader>ls", "<cmd>LspStart<cr>", { desc = "LSP: Start" })
	map("n", "<leader>lS", "<cmd>LspStart<cr>", { desc = "LSP: Stop" })

	-- Toggle keymaps
	for _, key in ipairs({ "b", "c", "d", "h", "i", "l", "n", "r", "s", "u", "v", "w", "x" }) do
		map("n", ("<leader>T" .. key), ("yo" .. key))
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
	--
	-- -- Typescript / Javascript
	-- keymap({
	-- 	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	-- 	callback = function(args)
	-- 		map_alternate(args.file, "(.+).([jt]sx?)", "%1.test.%2")
	-- 	end,
	-- })
	--
	-- keymap({
	-- 	pattern = { "*.test.ts", "*.test.tsx", "*.js", "*.jsx" },
	-- 	callback = function(args)
	-- 		map_alternate(args.file, "(.+).test.([jt]sx?)", "%1.%2")
	-- 	end,
	-- })
end

-- alternatives.setup()

return M
