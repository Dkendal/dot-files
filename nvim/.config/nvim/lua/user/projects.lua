local M = {}

---@alias CommandOptions { args: string, fargs: string[], bang: boolean, line1: number, line2: number, range: number, reg: string, mods: string }

local function data_file()
	return vim.fn.stdpath("data") .. "/projects.txt"
end

local function callback()
	local dir = vim.fn.fnamemodify(vim.fn.finddir(".git"), ":p:~:h:h")
	local path = data_file()
	local file = io.open(path, "r")

	---@type table<string, boolean>
	local projects = {}

	for line in file:lines() do
		projects[line] = true
	end

	projects[dir] = true

	io.close(file)

	file = io.open(path, "w+")

	for project in pairs(projects) do
		file:write(project .. "\n")
	end

	io.close(file)
end

local function project_add_current()
	local dir = vim.fn.fnamemodify(vim.fn.finddir(".git"), ":p:~:h:h")
	local path = data_file()
	local file = io.open(path, "rw")
	local lines = {}

	for line in file:lines() do
		lines[line] = true
	end

	lines[dir] = true

	for line in pairs(lines) do
		file:write(line .. "\n")
	end

	file:close()
end

---@return string[]
local function get_projects()
	local path = data_file()

	local file = io.open(path, "r")

	if not file then
		return
	end

	---@type string[]
	local lines = {}
	for line in file:lines() do
		table.insert(lines, line)
	end

	file:close()

	return lines
end

function M.find_project_root(search_path)
	search_path = search_path or ".;"
	local target = vim.fn.finddir(".git", search_path)
	local dir = vim.fn.fnamemodify(target, ":p:~:h:h")
	return dir
end

---@param t CommandOptions
local function cmd_project_add(t)
	local dir
	if t.args then
		dir = t.args
	else
		dir = M.find_project_root()
	end

	vim.notify(vim.inspect(dir))

	local path = data_file()
	local file = io.open(path, "r")
	local lines = {}
	local new = true

	for line in file:lines() do
		if line == dir then
			new = false
		end

		if string.match(line, "%s*") then
			lines[tostring(line)] = true
		end
	end

	lines[tostring(dir)] = true

	file:close()

	if new then
		file = io.open(path, "w")

		for line in pairs(lines) do
			file:write(line .. "\n")
		end

		file:close()
		vim.notify("Added project " .. dir)
	end
end

local function cmd_project_remove(t)
	local dir = t.fargs and t.fargs[1]
	local path = data_file()
	local file = io.open(path, "r")
	local lines = {}

	for line in file:lines() do
		lines[tostring(line)] = true
	end
	file:close()

	lines[tostring(dir)] = false

	file = io.open(path, "w")
	for line, value in pairs(lines) do
		vim.notify(vim.inspect({ line, value }))
		if value then
			file:write(line .. "\n")
		end
	end

	file:close()
end

local function cmd_project_list()
	vim.notify(vim.inspect(get_projects()))
end

local function cmd_project_open()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local themes = require("telescope.themes")
	local conf = require("telescope.config").values
	local actions_set = require("telescope.actions.set")
	local actions_state = require("telescope.actions.state")

	local results = get_projects()

	local function attach_mappings()
		actions_set.select:enhance({
			post = function()
				local selection = actions_state.get_selected_entry()
				vim.cmd([[lcd ]] .. selection[1])
			end,
		})

		return true
	end

	local finder = function(opts)
		opts = opts or {}
		pickers.new(opts, {
			prompt_title = "Projects",
			attach_mappings = attach_mappings,
			finder = finders.new_table({
				results = results,
			}),
			sorter = conf.file_sorter(opts),
		}):find()
	end

	finder(themes.get_ivy({}))
end

-- Open the file located at `data_file()`
local function cmd_project_data()
	vim.cmd([[e ]] .. data_file())
end

function M.init()
	local group = vim.api.nvim_create_augroup("user_projects", { clear = true })
	local ns = vim.api.nvim_create_namespace("user_projects")

	vim.api.nvim_create_autocmd({ "CursorHold", "BufRead", "BufWrite" }, {
		group = group,
		pattern = data_file(),
		callback = function()
			vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
			for index, line in ipairs(lines) do
				-- Check if file at `line` exists
				if vim.fn.glob(line) == "" then
					vim.api.nvim_buf_set_extmark(0, ns, index - 1, 0, {
						line_hl_group = "Error",
					})
				end
			end
		end,
	})

	vim.api.nvim_create_user_command("ProjectAdd", cmd_project_add, { nargs = "*" })
	vim.api.nvim_create_user_command("ProjectOpen", cmd_project_open, { nargs = 0 })
	vim.api.nvim_create_user_command("ProjectData", cmd_project_data, { nargs = 0 })
	vim.api.nvim_create_user_command("ProjectList", cmd_project_list, { nargs = 0 })
	vim.api.nvim_create_user_command("ProjectRemove", cmd_project_remove, { nargs = 1, complete = get_projects })

	-- 	vim.api.nvim_create_autocmd({ "BufRead" }, {
	-- 		group = group,
	-- 		pattern = "*",
	-- 		callback = cmd_project_add,
	-- 	})
end

M.init()

return M
