vim.api.nvim_create_user_command("Cd", function()
	local dir
	dir = vim.fn.expand("%:p")
	dir = vim.fn.finddir(".git", dir .. ";")
	dir = vim.fn.fnamemodify(dir, ":h")
	vim.api.nvim_set_current_dir(dir)
end, {force = true, desc = "Change root to nearest .git"})
