local F = require("strings").interpolate

local Mod = {}

local config = F("${home}/.local/share/nvim/background.vim", { home = vim.env.HOME })
local theme = "gruvbox"

-- Toggle the background color of the shell (Kitty)
local function shell_toggle(color)
	local conf = F("~/.config/kitty/colors/${theme}.${color}.conf", { theme = theme, color = color })
	local cmd = F("kitty @ set-colors --all --configured ${conf}", { conf = conf })
	os.execute(cmd)
end

-- Toggle background colour and save it between sessions.
function Mod.toggle()
	local background = "dark"

	if vim.o.background == "dark" then
		background = "light"
	else
		background = "dark"
	end

	vim.o.background = background
	shell_toggle(background)

	local file = io.open(config, "w+")

	if file == nil then
		local msg = F([[Failed to open "${file}"]], { file = config })
		error(msg)
	end

	file:write(F([[set background=${background}]], { background = background }))
	file:close()
end

function Mod.init()
	-- Persist background color between sessions
	vim.cmd("source " .. config)
end

Mod.init()

return Mod
