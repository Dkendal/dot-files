return {
	{
		desc = "pretty print",
		prefix = "p",
		body = [[vim.print(vim.inspect($0))]]
	}
}
