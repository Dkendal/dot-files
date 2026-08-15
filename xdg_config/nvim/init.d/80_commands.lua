local a = vim.api
local f = vim.fn
local command = a.nvim_create_user_command

local group = vim.api.nvim_create_augroup("user-commands", { clear = true })

a.nvim_create_autocmd({ "BufRead" }, {
	group = group,
	pattern = { "*.ejson" },
	callback = function()
		a.nvim_buf_create_user_command(0, "EjsonDecrypt", ":! ejson d % > %:r.json", {})
		a.nvim_buf_create_user_command(0, "EjsonEncrypt", ":! ejson e % && ejson d % > %:r.json", {})
	end,
})

local function reload_module()
	-- Get the current buffer's file path
	local current_file = vim.fn.expand("%:p")

	-- Check if the current file is a Lua file
	if not current_file:match("%.lua$") then
		print("Current file is not a Lua file.")
		return
	end

	-- Extract the module name from the file path
	local module_name = current_file:match("^.+/lua/(.+)%.lua$")

	if not module_name then
		print("Could not determine module name from file path.")
		return
	end

	-- Replace path separators with dots
	module_name = module_name:gsub("/", ".")

	-- Unload the module
	package.loaded[module_name] = nil

	-- Attempt to reload the module
	local success, result = pcall(require, module_name)

	if success then
		print("Successfully reloaded module: " .. module_name)
	else
		print("Failed to reload module: " .. module_name)
		print("Error: " .. result)
	end
end

local function gsub(t)
	local pattern = t.fargs[1]
	local replacement = t.fargs[2]
	local files = t.fargs[3]

	vim.cmd.vimgrep("'" .. pattern .. "'", files)

	vim.cmd.cfdo("%s/" .. pattern .. "/" .. replacement .. "/gceI")

	vim.cmd.cfdo("w")
end

local function change_dir()
	local dir
	dir = vim.fn.expand("%:p")
	dir = vim.fn.finddir(".git", dir .. ";")
	dir = vim.fn.fnamemodify(dir, ":h")
	vim.cmd([[silent cd ]] .. dir)
end

local function window_change_dir()
	local dir
	dir = vim.fn.expand("%:p")
	dir = vim.fn.finddir(".git", dir .. ";")
	dir = vim.fn.fnamemodify(dir, ":h")
	vim.cmd([[silent lcd ]] .. dir)
end

command("Gsub", gsub, { nargs = "*" })

command("Cd", change_dir, { force = true, desc = "Change root to nearest .git" })

command("Lcd", window_change_dir, { force = true, desc = "Change root to for this window nearest .git" })

command("TestNearest", function()
	require("neotest").run.run()
end, { force = true, desc = "Test the nearest file" })

command("TestFile", function()
	require("neotest").run.run(f.expand("%"))
end, { force = true, desc = "Test this file" })

command("HiTest", ":so $VIMRUNTIME/syntax/hitest.vim", { force = true, desc = "Run highlight test" })

command("StripAnsiCodes", [[:%s/\e\[[0-9;]*m//g]], { force = true, desc = "Remove all ANSI codes" })

command("YankMatches", function()
end, { force = true })

-- Command to call the function
command("ReloadModule", reload_module, {})

vim.api.nvim_create_user_command("CopyPath", function(opts)
	require("user.copy_path")(opts)
end, { range = true, bang = true })

local function yank_matches(reg)
	reg = reg or "+"
  local pat = vim.fn.getreg('/')
  if pat == '' then
    return vim.notify('no search pattern', vim.log.levels.WARN)
  end

  local view = vim.fn.winsaveview()
  local matches = {}
  vim.fn.cursor(1, 1)
  local flags = 'cW'

  while true do
    local s = vim.fn.searchpos(pat, flags)
    flags = 'W' -- no 'c' from here on, so the cursor always advances
    if s[1] == 0 then break end

    local e = vim.fn.searchpos(pat, 'cenW')
    if e[1] == 0 then break end

    local lines = vim.fn.getregion({ 0, s[1], s[2], 0 }, { 0, e[1], e[2], 0 }, { type = 'v' })
    table.insert(matches, table.concat(lines, '\n'))
    vim.fn.cursor(e[1], e[2])
  end

  vim.fn.winrestview(view)
  vim.fn.setreg(reg, table.concat(matches, '\n'))
  vim.notify(#matches .. ' matches → @' .. reg)
end


vim.api.nvim_create_user_command('YankMatches', function(opts)
  yank_matches(opts.reg ~= '' and opts.reg or nil)
end, {
  register = true,
  desc = 'Yank all matches of the last search pattern into a register',
})
