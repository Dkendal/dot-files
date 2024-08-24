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

ls.add_snippets("sql", {
	parse(
		"@distict",
		[[
		WITH RECURSIVE ${cte} AS ((SELECT *
														FROM ${1:table_name}
														ORDER BY ${1:table_name}.${2:col_name} DESC ${3}
														LIMIT 1)
													 UNION ALL
													 SELECT cte_next.*
													 FROM ${cte},
																LATERAL ( SELECT ${1:table_name}.*
																					FROM ${1:table_name}
																					WHERE ${1:table_name}.${2:col_name} < cte_next.${2:col_name}
																					ORDER BY ${1:table_name}.${2:col_name} DESC ${3}
																					LIMIT 1) cte_next)
		SELECT ${cte}.*
		FROM ${cte};
	]]
	),
}, { key = "sql" })
