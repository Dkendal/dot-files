local M = {}

function M.gsub(t)
	local pattern = t.fargs[1]
	local replacement = t.fargs[2]
	local files = t.fargs[3]

	vim.cmd.vimgrep("'" .. pattern .. "'", files)

	vim.cmd.cfdo("%s/" .. pattern .. "/" .. replacement .. "/gceI")

	vim.cmd.cfdo("w")
end

function M.gsub_preview(t)
	local pattern = t.args[1]
	local replacement = t.args[2]
end

vim.api.nvim_create_user_command("Gsub", M.gsub, { nargs = "*" })

return M
