local F = require("strings").interpolate

local M = {}

local vim_config = F("${home}/.local/share/nvim/background.vim", { home = vim.env.HOME })
local kitty_config = F("${home}/.config/kitty/colors.conf", { home = vim.env.HOME })
local theme = "gruvbox"

-- Toggle the background color of the shell (Kitty)
local function shell_toggle(color)
	local conf = F("~/.config/kitty/colors/${theme}.${color}.conf", { theme = theme, color = color })
	local cmd = F("kitty @ set-colors --all --configured ${conf}", { conf = conf })
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
		local msg = F([[Failed to open "${file}"]], { file = vim_config })
		error(msg)
	end

	file:write(F([[set background=${background}]], { background = background }))
	file:close()

	local file = io.open(kitty_config, "w+")

	if file == nil then
		local msg = F([[Failed to open "${file}"]], { file = kitty_config })
		error(msg)
	end

	vim.cmd("silent ! fish -c 'set -Ux BAT_THEME gruvbox-" .. background .. "'")

	file:write(F([[include colors/${theme}.${background}.conf]], { background = background, theme = theme }))
	file:close()
end

function M.init()
	-- Persist background color between sessions
	vim.cmd("source " .. vim_config)
end

return M
