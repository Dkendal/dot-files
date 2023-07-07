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

-- Javascript
ls.add_snippets("javascript", {

	-- Unknown
	s("?", t("unknown")),

	-- Await
	s("a", t("await ")),

	-- Export
	s("e", t("export ")),

	-- Const
	s("c", fmt("const {} = ", i(1))),

	-- Let
	s("l", fmt("let {} = ", i(1))),

	-- Pipe
	parse("|>", "pipe(${1:$TM_SELECTED_TEXT})", {}),

	-- jest.beforeEach
	parse("jbe", "beforeEach(() => {\n${TM_SELECTED_TEXT:$1}\n})", {}),

	-- jest.afterEach
	parse("jae", "afterEach(() => {\n${TM_SELECTED_TEXT:$1}\n})", {}),

	-- jest.beforeAll
	parse("jba", "beforeAll(() => {\n${TM_SELECTED_TEXT:$1}\n})", {}),

	-- jest.afterAll
	parse("jaa", "afterAll(() => {\n${TM_SELECTED_TEXT:$1}\n})", {}),

	-- Typedoc
	parse("@type", "/** @type {$1} */", {}),
	parse("@const", "/** @const */", {}),

	parse("de", [[require("debug").enable("${1:*}")]], {}),
	parse("rd", [[const ${1:log} = require("debug")("${2:TM_FILENAME}");]], {}),
	parse("cp", [[require("console-probe").probe(${1:$TM_SELECTED_TEXT})]], {}),
	parse("ls", [[require("console-probe").ls(${1:$TM_SELECTED_TEXT})]], {}),
	parse("ls", [[require("console-probe").yaml(${1:$TM_SELECTED_TEXT})]], {}),
	parse("json", [[require("console-probe").json(${1:$TM_SELECTED_TEXT})]], {}),
	parse("ifr", [[if ($1) return ${2:$TM_SELECTED_TEXT}]], {}),

	-- Fp-ts
	parse("fmap", [[${1:E}.map(x => { ${2:return x} })]], {}),
	parse("chain", [[${1:E}.chain(x => { ${2:return x} })]], {}),
	parse("pt", [[x => { require("console-probe").ls(${1:x}); return x }]], {}),

	-- Class
	s(
		"class",
		fmt(
			[[
				class {} {{
					constructor({}) {{
						{}
					}}
				}}
			]],
			{ i(1), i(2), i(0) }
		)
	),
	-- Error Class
	s(
		"eclass",
		fmt(
			[[
				class {}Error extends Error {{
					{}
				}}
			]],
			{
				i(1),
				c(2, {
					t(""),
					isn(
						nil,
						fmt(
							[[
								constructor({}) {{
									super(message);
								}}
							]],
							{ i(1, "public message") }
						),
						"  "
					),
				}),
			}
		)
	),
	-- Function
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
	-- Arrow function
	s(
		"af",
		fmta("(<>) =>> <><>", {
			i(1, "x"),
			d(2, function(args)
				return sn(nil, i(1, args[1][1]))
			end, { 1 }),
			i(0),
		})
	),
	s(
		"fd",
		fmt("({{ {} }}) => {}", {
			i(1),
			f(copy, 1),
		})
	),
	-- Jest test
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
	-- Jest describe
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
		"@id",
		fmta([[import  <> from "<>";]], {
			d(2, ts_import_default_name, { 1 }),
			i(1),
		})
	),
	s(
		"@ia",
		fmta([[import * as <> from "<>";]], {
			d(2, ts_import_default_name, { 1 }),
			i(1),
		})
	),
	-- Import all acronym
	s(
		"@iaa",
		fmta([[import * as <> from "<>";]], {
			d(2, function(args)
				local txt = args[1][1]
				txt = string.gsub(txt, "/$", "")

				local tokens = vim.split(txt, "/", { plain = true })

				local txt = tokens[#tokens]

				if #txt == 0 then
					txt = args[1][1]
				end

				txt = string.gsub(txt, "-(%l)", function(str)
					return string.upper(str)
				end)

				txt = string.gsub(txt, "^(%l)", function(str)
					return string.upper(str)
				end)

				txt = string.gsub(txt, "%l+", "")

				txt = string.gsub(txt, "[-/]", "")

				return sn(nil, i(1, txt))
			end, { 1 }),
			i(1),
		})
	),
	s(
		"@i",
		fmta([[import { <> } from "<>";]], {
			d(2, ts_import_default_name, { 1 }),
			i(1),
		})
	),
	parse("int", "interface $1 {\n\t$0\n}"),
	parse("p", [[console.debug(${1:$TM_SELECTED_TEXT})]]),
	parse("put", [[console.info(${1:$TM_SELECTED_TEXT})]]),
	parse(
		"pp",
		[[console.log(require('util').inspect(${1:$TM_SELECTED_TEXT}, {depth: 3, colors: true, maxStringLength: 50, maxArrayLength: 10}))]]
	),
	s(
		"data",
		fmta(
			[[
			interface <interface_name><<<type_arguments>>> {
				<interface_body>
			}

			function <constructor_name><<<type_arguments_2>>>(<constructor_args>): <return_type> {
				return {
					<constructor_body>
				};
			}
		]],
			{
				interface_name = i(1),

				type_arguments = i(2),

				type_arguments_2 = cp(2),

				return_type = f(function(args)
					local interface = args[1][1]
					local txt = args[2][1]
					local terms = vim.split(txt, ", *", { trimempty = type })

					local out = {}
					for _, term in ipairs(terms) do
						local type = vim.split(term, " ")[1]
						table.insert(out, type)
					end

					txt = table.concat(out, ", ")

					return string.format("%s<%s>", interface, txt)
				end, { 1, 2 }),

				constructor_name = f(function(args)
					return camel_case(args[1][1])
				end, { 1 }),

				constructor_body = f(function(args)
					local txt = args[1][1]
					local terms = vim.split(txt, ", *", { trimempty = type })

					local out = {}
					for _, term in ipairs(terms) do
						local type = vim.split(term, " ")[1]
						table.insert(out, camel_case(type))
					end

					txt = table.concat(out, ", ")

					return txt
				end, { 2 }),

				interface_body = f(function(args)
					local txt = args[1][1]
					local terms = vim.split(txt, ", *", { trimempty = type })

					local out = {}
					for _, term in ipairs(terms) do
						local type = vim.split(term, " ")[1]
						table.insert(out, string.format("%s: %s", camel_case(type), type))
					end

					return table.concat(out, "; ")
				end, { 2 }),

				constructor_args = f(function(args)
					local txt = args[1][1]
					local terms = vim.split(txt, ", *", { trimempty = type })

					local out = {}
					for _, term in ipairs(terms) do
						local type = vim.split(term, " ")[1]
						table.insert(out, string.format("%s: %s", camel_case(type), type))
					end

					return table.concat(out, ", ")
				end, { 2 }),
			}
		)
	),
	s("v", fmt("{} {} = {}", { c(1, { t("const"), t("let"), t("var") }), i(2), i(3) })),
	s("pi", t("// prettier-ignore")),
	s("esli", t("// eslint-disable-next-line")),
	parse("ex", "expect($1)"),
	parse("te", "toEqual($1)"),
}, { key = "javascript" })

ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend("typescriptreact", { "javascript" })
ls.filetype_extend("javascriptreact", { "javascript" })
