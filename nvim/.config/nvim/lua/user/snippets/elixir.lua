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

ls.add_snippets("elixir", {
	parse("i", "IO.inspect($1)", {}),
	parse("<<", "<%= $0 %>", {}),
	parse("<", "<% $0 %>", {}),
	parse(
		"<for",
		[[
			<%= for ${1:elem} <- ${2:enum} do %>
				${0}
			<% end %>
		]],
		{}
	),
	parse(
		"<inputs_for",
		[[
			<div :for={${1:form} <- Phoenix.HTML.Form.inputs_for(${2:@form}, ${3:assoc})}>
				<%= Phoenix.HTML.Form.hidden_inputs_for(${1:form}) %>

				${0}
			</div>
		]],
		{}
	),
	parse(
		"<if",
		[[
			<%= if ${1:true} do %>
				${0}
			<% end %>
		]],
		{}
	),
}, { key = "elixir" })
