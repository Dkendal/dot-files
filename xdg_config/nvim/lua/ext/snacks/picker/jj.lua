local M = {}

function M.jj_status(_opts, ctx)
	local cwd = Snacks.git.get_root() or vim.uv.cwd() or "."
	return require("snacks.picker.source.proc").proc({
		cmd = "jj",
		args = { "status", "--no-pager" },
		cwd = cwd,
		transform = function(item)
			-- Skip header lines and empty lines
			if
				item.text:match("^Working copy changes:")
				or item.text:match("^Working copy%(@%)")
				or item.text:match("^Parent commit")
				or item.text:match("^Warning:")
				or item.text:match("^Hint:")
				or item.text == ""
			then
				return false
			end

			-- Parse status lines like "A path/to/file" or "M path/to/file"
			local status, file = item.text:match("^([AMD?R])%s+(.+)$")
			if status then
				item.file = file
				item.status = status
				item.cwd = cwd
				return true
			else
				return false
			end
		end,
	}, ctx)
end

function M.vcs_status()
	-- Check if we're in a jj repository (look for .jj directory upwards)
	local is_jj_repo = vim.fn.finddir(".jj", ".;") ~= ""
	if is_jj_repo then
		require("snacks.picker").pick({
			source = "jj_status",
			finder = M.jj_status,
		})
	else
		require("snacks.picker").git_status()
	end
end

return M
