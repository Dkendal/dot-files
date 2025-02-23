return {
	{
		trigger = "v4",
		body = "Faker.UUID.v4()",
	},
	{
		trigger = "desc",
		body = [[
				describe "${1:module}" do
					${0}
				end
			]],
	},
	{
		trigger = "test",
		body = [[
				test "${1:does something}" do
					${0}
				end
			]],
	},
	{
		trigger = "defm",
		body = [[
				defmodule ${1:ModuleName} do
					${0}
				end
			]],
	},
	{
		trigger = "fn",
		body = [[
				fn $1 ->
					$2
				end
			]],
	},
	{
		trigger = "for",
		body = [[
				for $1 <- $2 do
					$0
				end
			]],
	},
	{
		trigger = "if",
		body = [[
				if $1 do
					$0
				end
			]],
	},
	{
		trigger = "<<",
		body = [[
				<%= $0 %>
			]],
	},
	{
		trigger = "<",
		body = [[
				<% $0 %>
			]],
	},
	{
		trigger = "i",
		body = [[IO.inspect($0)]],
	}
}
