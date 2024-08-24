local M = {}

local a = vim.api
local f = vim.fn

local ns = a.nvim_create_namespace("user-ft")
local group = vim.api.nvim_create_augroup("user-ft", { clear = true })

function M.init()
	a.nvim_buf_clear_namespace(0, ns, 0, -1)

	autocmd({}, {
		group = group,
		pattern = "",
		callback = function() end,
	})
end

M.init()

return M
