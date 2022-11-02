local M = {}

function M.pp(node, depth)
	depth = depth or 0

	if node:named() then
		print(string.format("%s%s", string.rep(" ", depth), node:type()))
	end

	local idx = 0
	for child in node:iter_children() do
		M.pp(child, depth + 1)
		idx = idx + 1
	end
end

return M
