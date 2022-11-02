local pp = require("user.tree-sitter").pp
local ts = vim.treesitter
local M = {}

local function cmp(field)
	return function(a, b)
		return a[field] < b[field]
	end
end

local function cmp_import_source_value(x)
	if string.match(x, "^(%w)") then
		return "00" .. x
	elseif string.match(x, "^(@)") then
		return "00" .. x
	elseif string.match(x, "^(%.%./)") then
		return "10" .. x
	elseif string.match(x, "^(%.)") then
		return "20" .. x
	elseif string.match(x, "^(:/)") then
		return "30" .. x
	elseif string.match(x, "^(~/)") then
		return "30" .. x
	elseif string.match(x, "^(#mock)") then
		return "99" .. x
	elseif string.match(x, "^(#)") then
		return "40" .. x
	else
		return "50" .. x
	end
end

local function cmp_import_source(a, b)
	return cmp_import_source_value(a.source) < cmp_import_source_value(b.source)
end

local function copy(t)
	local t2 = {}
	for k, v in pairs(t) do
		t2[k] = v
	end
	return t2
end

-- Sort all the named imports, and import statements within a document using
-- tree-sitter.
function M.sort()
	local query = ts.parse_query(
		"typescript",
		[[
			(
				((comment) @comment)?
				.
				(import_statement
					(import_clause
							(named_imports
								((import_specifier) @import_specifier)))?
					source: (string ((string_fragment) @source)))
				@import_statement
				(#vim-match? @comment "^(/[/*]\\s*import-sort:ignore)@!")
			)
		]]
	)

	local parser = ts.get_parser(0, vim.o.filetype, {})
	local tree = parser:parse()[1]

	local stack = {}

	local function top()
		return stack[#stack]
	end

	for id, node, meta in query:iter_captures(tree:root(), 0, 0, -1) do
		local name = query.captures[id]

		if name == "import_statement" then
			if not top() or top().import_statement:id() ~= node:id() then
				table.insert(stack, {})
			end

			top().import_statement = node
		elseif name == "import_specifier" then
			top().import_specifiers = top().import_specifiers or {}
			table.insert(top().import_specifiers, {
				text = ts.get_node_text(node, 0),
				node = node,
			})
		elseif name == "source" then
			top().source = ts.get_node_text(node, 0)
		end
	end

	local replacements = vim.tbl_map(function(x)
		-- Sort the import specifiers.
		local specs = x.import_specifiers
		if specs then
			local specs_sorted = copy(specs)
			table.sort(specs_sorted, cmp("text"))
			-- Apply changes in reverse order so that the offsets don't change
			for i = #specs, 1, -1 do
				local node = specs[i].node
				local sr, sc, er, ec = node:range()
				local lines = { specs_sorted[i].text }
				vim.api.nvim_buf_set_text(0, sr, sc, er, ec, lines)
			end
		end

		local lines = ts.get_node_text(x.import_statement, 0, { concat = false })

		return {
			source = x.source,
			lines = lines,
		}
	end, stack)

	table.sort(replacements, cmp_import_source)

	-- Sort import statements.
	-- Apply changes in reverse order so that the offsets don't change.
	for i = #stack, 1, -1 do
		local item = stack[i]
		local node = item.import_statement
		local sr, sc, er, ec = node:range()
		vim.api.nvim_buf_set_text(0, sr, sc, er, ec, replacements[i].lines)
	end
end

function M.init()
	vim.api.nvim_buf_create_user_command(0, "SortImports", "lua require('user.typescript-sort').sort()", {})
end

return M
