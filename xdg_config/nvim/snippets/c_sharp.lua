local dedent = require("user.strings.dedent")

return {
	{
		desc = "Print",
		prefix = "p",
		body = [[GD.Print($0);]]
	},
	{
		desc = "ECS Update method",
		prefix = "/update",
		body = dedent([[
			[Query]
			[MethodImpl(MethodImplOptions.AggressiveInlining)]
			public void Update(ref Entity entity)
			{
				$0
			}
		]])
	},
	{
		desc = "ECS query",
		prefix = "/query",
		body = dedent([[
    var query = new QueryDescription();
    World.Query(
      in query,
      (Entity e) =>
      {
      }
		]])
	}
}
