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

local function get_module_name()
	local mix = vim.fn.findfile("mix.exs", ".;") -- Find mix.exs in current dir or up.
	mix = vim.fn.fnamemodify(mix, ":p:h")
	local path = vim.api.nvim_buf_get_name(0)
	path = vim.fn.fnamemodify(path, ":p:r")
	local s, e = string.find(path, mix, 1, true)
	path = string.sub(path, e + 2, -1)
	local text = path

	-- Remove the leading "lib/" or "test/"
	if string.sub(text, 1, 4) == "lib/" then
		text = string.sub(text, 5, -1)
	elseif string.sub(text, 1, 5) == "test/" then
		text = string.sub(text, 6, -1)
	end

	text = string.gsub(text, "^(%w)", function(c)
		return string.upper(c)
	end)

	text = string.gsub(text, "/(%w)", function(c)
		return "." .. string.upper(c)
	end)

	text = string.gsub(text, "_(%w)", function(c)
		return string.upper(c)
	end)

	return text
end

ls.add_snippets("elixir", {
	parse("i", "IO.inspect($1)", {}),
	parse(
		"fn",
		[[
			fn $1 ->
				$0
			end
		]],
		{}
	),
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
	-- Testing
	parse(
		"desc",
		[[
			describe "${1:module}" do
				${0}
			end
		]],
		{}
	),
	parse(
		"test",
		[[
			test "${1:does something}", ${2:_} do
				${0}
			end
		]],
		{}
	),
	-- Expand to a new module definition, auto infer the module name from the path.
	ls.snippet(
		"defm",
		fmt(
			[[
				defmodule {module_name} do
					{inner_block}
				end
			]],
			{
				module_name = ls.dynamic_node(1, function(args)
					local text = get_module_name()
					return ls.snippet_node(nil, ls.insert_node(1, text))
				end),

				inner_block = ls.dynamic_node(2, function(args)
					local text = get_module_name()

					local re = vim.regex("Test$")

					if re:match_str(text) then
						local module_name = string.sub(text, 1, -5)

						return ls.snippet_node(nil, {
							ls.indent_snippet_node(1, {
								ls.text_node({
									"use ExUnit.Case, async: true",
									"doctest " .. module_name .. ", import: true",
									"",
									"alias " .. module_name,
								}),
								i(1),
							}, "\t"),
						})
					end

					return ls.snippet_node(nil, { i(0) })
				end),
			}
		)
	),
}, { key = "elixir" })
