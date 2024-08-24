local ts = vim.treesitter
local a = vim.api
local f = vim.fn

vim.o.matchpairs = [[(:),{:},[:],<:>]]

require("user.typescript-sort").init()

vim.api.nvim_buf_create_user_command(0, "DeleteUnusedImports", function()
	local query = ts.parse_query(
		"typescript",
		[[
			(import_statement
				(import_clause
					(named_imports
						(import_specifier) @specifier)))

			(type_identifier) @type_id

			(identifier) @id
		]]
	)

	local parser = ts.get_parser(0, vim.o.filetype, {})
	local tree = parser:parse()[1]

	for id, node, meta in query:iter_captures(tree:root(), 0, 0, -1) do
	end
end, {})

vim.api.nvim_buf_create_user_command(0, "Swc", "! yarn run swc % -o %:r.js", {})
