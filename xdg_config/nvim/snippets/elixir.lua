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
		body = [[
			desc "$1" do
				$0
			end
		]]
	},
	{
		desc = "test block",
		prefix = "test",
		body = [[
			test "$1", state do
				$0
			end
		]]
	},
	{
		desc = "@tr",
		prefix = "dbg trace",
		body = [[
			Dbg.trace()
			Dbg.process(:all, :c)
		]]
	}
}
