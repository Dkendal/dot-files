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

ls.add_snippets("haskell", {
	-- prefill the module name based on the relative path to the current filee
	-- Example file name: src/MyApp/A/B/C.hs
	-- Expected snippet: module MyApp.A.B.C where
	s("module", {
		t("module "),
		d(1, function(args, parent)
			local path = vim.fn.expand("%:.")
			local module = path:match("^src/(.*)%.hs$")
			if module then
				module = module:gsub("/", ".")
				return sn(nil, t(module))
			end
			return sn(nil, i(1))
		end),
		t(" where"),
	}),
	parse("desc", [[describe "${1:describe}" $ do $0]], {}),
	parse("test", [[test "${1:test}" $ do $0]], {}),
	parse("spec", [[specify "${1:specify}" $ do $0]], {}),
	parse("iq", "import qualified ${1:module} as ${2:alias}", {}),
	parse("im", "import ${1:module}", {}),
	parse("il", "import qualified ${1:module}", {}),
	parse("let", "let ${1:var} = ${2:val} in ${3:body}", {}),
	parse("<-", "${1:var} <- ${2:val}", {}),
}, { key = "haskell" })
