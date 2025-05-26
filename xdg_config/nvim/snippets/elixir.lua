local dedent = require("user.string").dedent

return {
	{
		desc = "IO.puts",
		prefix = "p",
		body = [[IO.puts($0)]]
	},
	{
		desc = "dbg",
		prefix = "d",
		body = [[dbg($0)]]
	},
	{
		desc = "describe block",
		prefix = "desc",
		body = dedent([[
			desc "$1" do
				$0
			end
		]])
	},
	{
		desc = "test block",
		prefix = "test",
		body = dedent([[
			test "$1", state do
				$0
			end
		]])
	},
	{
		desc = "@dbg",
		prefix = "dbg tracer",
		body = dedent([[
			Dbg.tracer()
			Dbg.process(:all, :c)
		]])
	},
	{
		desc = ":",
		prefix = "property",
		body = [[$1: $1]]
	}
}
