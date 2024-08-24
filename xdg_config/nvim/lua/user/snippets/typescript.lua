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

ls.add_snippets("typescriptreact", {
	parse(
		"@next.page",
		[[
		export const Page: NextPage<Props> = (props: Props) => {
			return (
				<Layout>
					<div>
						$0
					</div>
				</Layout>
			);
		}

		export default Page;
		]]
	),

	parse("{/", [[{/* $0 */}]]),

	parse(
		"@fc",
		[[
		export function ${1:Component}(props: {}) {
			return (<div>$0</div>);
		};
		]]
	),

	parse(
		"@next.gssp",
		[[
		export const getServerSideProps = async (ctx: GetServerSidePropsContext) => {
			return {
				props: {}
			};
		}

		type Props = InferGetServerSidePropsType<typeof getServerSideProps>;
		]]
	),
}, { key = "typescriptreact" })

ls.add_snippets("typescript", {
}, { key = "typescript" })

ls.filetype_extend("typescriptreact", { "typescript" })
