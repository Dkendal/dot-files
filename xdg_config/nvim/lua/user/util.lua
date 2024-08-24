local M = {}

--- Define a keymap
function M.map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent or true
	local ok, res = xpcall(vim.keymap.set, debug.traceback, mode, lhs, rhs, opts)

	if not ok then
		vim.notify(
			string.format(
				"Error setting keymap mode:%s lhs:%s rhs:%s opts:%s: %s",
				mode,
				vim.inspect(lhs),
				vim.inspect(rhs),
				vim.inspect(opts),
				res
			),
			vim.log.levels.ERROR
		)
	end
end

--- Apply a function to a list of arguments
function M.apply(func, ...)
	local args = { ... }
	return function(...)
		return func(unpack(vim.tbl_flatten({ args, { ... } })))
	end
end

--- Feed keys
function M.feedkeys(keys)
	vim.api.nvim_feedkeys(t(keys), "n", false)
end

--- Replace termcodes
function M.t(str)
	return vim.api.nvim_replace_termcodes(str, true, false, true)
end



return M
