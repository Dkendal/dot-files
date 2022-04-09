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

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
	return args[1]
end

-- snippets are added via ls.add_snippets(filetype, snippets[, opts]), where
-- opts may specify the `type` of the snippets ("snippets" or "autosnippets",
-- for snippets that should expand directly after the trigger is typed).
--
-- opts can also specify a key. By passing an unique key to each add_snippets, it's possible to reload snippets by
-- re-`:luafile`ing the file in which they are defined (eg. this one).
ls.add_snippets("all", {
	s("(", { t("( "), i(0), t(" )") }),
	s("{", { t("{ "), i(0), t(" }") }),
	s("[", { t("[ "), i(0), t(" ]") }),
	s("<", { t("< "), i(0), t(" >") }),
	s("${", { t("${ "), i(0), t(" }") }),
	s("`", { t("`"), i(0), t("`") }),
}, {
	key = "all",
})

ls.add_snippets("javascript", {
	s(
		"f",
		fmta(
			[[
			<>function <>( <> ) {
				<>
			}
			]],
			{ c(1, { t(""), t("async ") }), i(2), i(3), i(0) }
		)
	),
	s(
		"fl",
		fmta("() =>> { <> }", {
			i(0),
		})
	),
	s(
		"fa",
		fmta("( <> ) =>> {\n\t<>\n}", {
			i(1),
			i(0),
		})
	),
	s(
		"fr",
		fmt("({}) => {}", {
			i(1),
			f(copy, 1),
		})
	),
	s(
		"fd",
		fmt("({{ {} }}) => {}", {
			i(1),
			f(copy, 1),
		})
	),
	s("e", t("export ")),
	s(
		"test",
		fmt(
			[[
			test("{msg}", async () => {{
				{body}
			}});
			]],
			{
				msg = i(1, "does this thing"),
				body = i(2, "expect(1).toEqual(1)"),
			}
		)
	),
	s(
		"desc",
		fmt(
			[[
			describe("{msg}", () => {{
				{tests}
			}});
			]],
			{
				msg = i(1, "does this thing"),
				tests = i(0),
			}
		)
	),
	s(
		"id",
		fmta([[import <1><2> from "<3>";]], {
			c(1, { t("* as "), t("") }),
			i(2),
			i(3),
		})
	),
	s(
		"i",
		fmta([[import { <> } from "<>";]], {
			i(1),
			i(2),
		})
	),
	s(
		"i",
		fmta([[import { <> } from "<>";]], {
			i(1),
			i(2),
		})
	),
	s("v", fmt("{} {} = {}", { c(1, { t("const"), t("let"), t("var") }), i(2), i(3) })),
	s("pp", fmt("require('console-probe').probe({})", { i(1) })),
	s("p", fmt("console.log({})", { i(1) })),
})

ls.filetype_extend("typescript", { "javascript" })

ls.filetype_extend("lua", { "c" })

-- ls.filetype_set("cpp", { "c" })

-- Enable vscode snippets
-- require("luasnip.loaders.from_vscode").lazy_load() -- You can pass { paths = "./my-snippets/"} as well
