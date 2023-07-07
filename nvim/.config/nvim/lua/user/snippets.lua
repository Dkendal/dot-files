local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local isn = ls.indent_snippet_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local parse = ls.parser.parse_snippet

local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

for _, lang in ipairs({
	"typescript",
	"javascript",
	"elixir",
	"heex",
	"golang",
	"lua",
	"rust",
}) do
	require("user/snippets/" .. lang)
end

local function camel_case(txt)
	txt = string.gsub(txt, "^(%u)", function(char)
		return string.lower(char)
	end)

	txt = string.gsub(txt, "-(%l)", function(str)
		return string.upper(str)
	end)

	txt = string.gsub(txt, "_(%l)", function(str)
		return string.upper(str)
	end)

	return txt
end

-- If you're reading this file for the first time, best skip to around line 190
-- where the actual snippet-definitions start.

-- Every unspecified option will be set to the default.
ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	update_events = "TextChanged,TextChangedI",
	-- Snippets aren't automatically removed if their text is deleted.
	-- `delete_check_events` determines on which events (:h events) a check for
	-- deleted snippets is performed.
	-- This can be especially useful when `history` is enabled.
	delete_check_events = "TextChanged",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	enable_autosnippets = false,
	-- mapping for cutting selected text so it's usable as SELECT_DEDENT,
	-- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
	store_selection_keys = "<Tab>",
	-- luasnip uses this function to get the currently active filetype. This
	-- is the (rather uninteresting) default, but it's possible to use
	-- eg. treesitter for getting the current filetype by setting ft_func to
	-- require("luasnip.extras.filetype_functions").from_cursor (requires
	-- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
	-- the current filetype in eg. a markdown-code block or `vim.cmd()`.
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})

local function copy(args)
	return args[1]
end

local function cp(index)
	return f(function(args)
		return args[1]
	end, { index })
end

local function ts_import_default_name(args)
	local txt = args[1][1]
	txt = string.gsub(txt, "/$", "")

	local tokens = vim.split(txt, "/", { plain = true })

	local txt = tokens[#tokens]

	if #txt == 0 then
		txt = args[1][1]
	end

	txt = camel_case(txt)
	txt = string.gsub(txt, "[-/]", "")

	return sn(nil, i(1, txt))
end

-- snippets are added via ls.add_snippets(filetype, snippets[, opts]), where
-- opts may specify the `type` of the snippets ("snippets" or "autosnippets",
-- for snippets that should expand directly after the trigger is typed).
--
-- opts can also specify a key. By passing an unique key to each add_snippets, it's possible to reload snippets by
-- re-`:luafile`ing the file in which they are defined (eg. this one).
ls.add_snippets("all", {}, {
	key = "all",
})

-- Haskell
ls.add_snippets("haskell", {
	s(
		"desc",
		fmt(
			[[
				describe "does the thing" $ do
				  {}
			]],
			{ i(0) }
		)
	),
	s(
		"it",
		fmt(
			[[
				it "does the thing" $ do
					1 `shouldBe` 1
			]],
			{}
		)
	),
}, { key = "haskell" })

ls.filetype_extend("lua", { "c" })
