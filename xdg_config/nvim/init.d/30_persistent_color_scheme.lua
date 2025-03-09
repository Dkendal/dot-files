local data = vim.fn.stdpath("data")
local colorscheme_file = vim.fs.joinpath(data, "colorscheme")
assert(type(data) == "string", "data is not a string")

local function write_colorscheme()
	assert(type(data) == "string", "data is not a string")
	vim.fn.writefile({ vim.o.background, vim.g.colors_name }, colorscheme_file)
end

local function load_colorscheme()
	local color_data = vim.fn.readfile(colorscheme_file)
	assert(type(color_data) == "table", "data is not a table")
	assert(#color_data == 2, "data is not the correct length")
	vim.o.background = color_data[1]
	vim.cmd("colorscheme " .. color_data[2])
end

local function setup()
	if vim.fn.filereadable(colorscheme_file) == 1 then
		load_colorscheme()
	end

	-- Save the colorscheme to disk when changed
	vim.api.nvim_create_autocmd({ "ColorScheme" }, {
		pattern = "*",
		callback = write_colorscheme,
	})
end

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "VeryLazy",
	callback = setup
})
