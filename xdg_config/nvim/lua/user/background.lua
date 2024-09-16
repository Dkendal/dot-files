local fmt = string.format
local join = vim.fs.joinpath
local HOME = vim.env.HOME
local M = {}

local vim_config = join(HOME, ".local/share/nvim/background.vim")
local kitty_config = join(HOME, ".config/kitty/colors.conf")
local theme = "gruvbox"

-- Toggle the background color of the shell (Kitty)
local function shell_toggle(color)
	local conf = fmt("~/.config/kitty/colors/%s.%s.conf", theme, color)
	local cmd = fmt("kitty @ set-colors --all --configured %s", conf)
	os.execute(cmd)
end

-- Toggle background colour and save it between sessions.
function M.toggle()
	local background = "dark"

	if vim.o.background == "dark" then
		background = "light"
	else
		background = "dark"
	end

	vim.o.background = background
	shell_toggle(background)

	local file = io.open(vim_config, "w+")

	if file == nil then
		local msg = fmt([[Failed to open "%s"]], vim_config)
		error(msg)
	end

	file:write(fmt([[set background=%s]], background))
	file:close()

	local file = io.open(kitty_config, "w+")

	if file == nil then
		local msg = fmt([[Failed to open "%s"]], kitty_config)
		error(msg)
	end

	vim.cmd("silent ! fish -c 'set -Ux BAT_THEME gruvbox-" .. background .. "'")

	file:write(fmt([[include colors/%s.%s.conf]], background, theme))
	file:close()
end

function M.init()
	-- Persist background color between sessions
	if vim.fn.filereadable(vim_config) == 1 then
		vim.cmd("source " .. vim_config)
	end
end

return M
