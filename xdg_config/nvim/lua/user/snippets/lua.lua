local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local parse = ls.parser.parse_snippet

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

-- Neovim specific snippets
ls.add_snippets("lua", {
	-- Create autocommand group
	s(
		"aug",
		fmta(
			[[
				local group = vim.api.nvim_create_augroup("<group_name>", { clear = true })
			]],
			{
				group_name = i(1, "my-group"),
			}
		)
	),
	-- Create autocommand
	s(
		"au",
		fmta(
			[[
				vim.api.nvim_create_autocmd(<event>, {
					group = <group>,
					pattern = <pattern>,
					callback = <callback>,
				}
			]],
			{
				event = i(1, [["BufRead"]]),
				group = i(2, "group"),
				pattern = i(3, [["*"]]),
				callback = i(4, "callback"),
			}
		)
	),
	-- Create mapping
	s(
		"map",
		fmta([[vim.keymap.set(<mode>, <lhs>, <rhs>, <opts>)]], {
			mode = i(1, [["n"]]),
			lhs = i(2, [["<leader>"]]),
			rhs = i(3, [["<cmd>echo 'Hello World!'<cr>"]]),
			opts = i(4, [[{}]]),
		})
	),

	-- Create command
	s(
		"command",
		fmta([[vim.api.nvim_create_user_command(<name>, <cmd>, <opts>)]], {
			name = i(1, [["MyCommand"]]),
			cmd = i(2, [[function() print("Hello World!") end]]),
			opts = i(3, [[{}]]),
		})
	),
}, { key = "lua-nvim" })

ls.add_snippets("lua", {
	-- Local
	s("l", fmt("local {} = {}", { i(1), i(2) })),
	-- Pipe
	parse("|>", "pipe(${TM_SELECTED_TEXT:$1})", {}),
	-- Local assignment
	s(
		"la",
		fmt("local {} = {}", {
			f(function(args)
				local txt = args[1][1]
				local tokens = vim.split(txt, ".", { plain = true })
				local var_name = tokens[#tokens]
				if #var_name > 0 then
					return var_name
				end
				return args[1]
			end, { 1 }),
			i(1),
		})
	),
	-- Return
	s("r", t("return ")),
	-- Require
	s(
		"req",
		fmt('local {} = require("{}")', {
			f(function(args)
				local txt = args[1][1]
				local tokens = vim.split(txt, ".", { plain = true })
				local var_name = tokens[#tokens]
				if #var_name > 0 then
					return var_name
				end
				return args[1]
			end, { 1 }),
			i(1),
		})
	),
	-- Function
	s(
		"f",
		fmt(
			[[
			function {}({})
				{}
			end
			]],
			{ i(1), i(2), i(0) }
		)
	),
	-- Local function
	s(
		"lf",
		fmt(
			[[
			local function {}({})
				{}
			end
			]],
			{ i(1), i(2), i(0) }
		)
	),
	parse("p", "vim.print($1)", {}),
	parse("pp", "vim.print(vim.inspect($1))", {}),
	parse("@a", "---@alias", {}),
	-- Pcall
	s(
		"pcall",
		fmt(
			[[
			pcall(function ()
				{}
			end)
			]],
			{ i(0) }
		)
	),
	parse(
		"desc",
		[[
			describe("$1", function ()
				$0
			end)
		]]
	),
	parse(
		"it",
		[[
			it("$1", function ()
				$0
			end)
		]]
	),
	parse("@t", [[---@type $0]]),
	parse("@p", [[---@param $0]]),
	parse("@r", [[---@return $0]]),
	parse("@f", [[---@field $0]]),
	parse("@c", [[---@class $0]]),
}, { key = "lua" })
