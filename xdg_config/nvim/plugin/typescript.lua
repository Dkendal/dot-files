local function callback()
	vim.keymap.set({ "v", "n" }, "<leader>ev", function()
		---@type string[]
		local buff = {}

		if vim.fn.mode() == "n" then
			table.insert(buff, vim.api.nvim_get_current_line())
		else
			error "Not implemented"
		end

		---@type string[]
		local result = vim.fn.systemlist("node -p -", buff)

		vim.fn.setreg("+", table.concat(result, "\n"))
	end, { buffer = true })
end

local group = vim.api.nvim_create_augroup("user-typescript", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = group,
	pattern = { "*.ts" },
	callback = callback,
})
