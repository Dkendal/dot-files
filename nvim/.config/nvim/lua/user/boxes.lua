local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local F = require("strings").interpolate

local M = {}

M.ft_opts = {
	toml = "-d shell",
	Earthfile = "-d shell",
	yaml = "-d shell",
	lua = "-d ada-box",
	fennel = "-d lisp",
	elixir = "-d shell",
}

M.opts = [[]]

function M.enable()
	local ft = vim.bo.filetype
	local indent = 79 - fn.indent(".")

	local opts = M.ft_opts[ft]

	if not opts then
		opts = ""
	end

	vim.cmd(string.format([['<,'>!boxes %s -s %s %s]], M.opts, indent, opts))
end

function M.disable()
	local ft = vim.bo.filetype
	local indent = 79 - fn.indent(".")

	local opts = M.ft_opts[ft]

	if not opts then
		opts = ""
	end

	vim.cmd(string.format([['<,'>!boxes -r %s -s %s %s]], M.opts, indent, opts))
end

function M.toggle()
	local ft = vim.bo.filetype
	local indent = 79 - fn.indent(".")

	local opts = M.ft_opts[ft]

	if not opts then
		opts = ""
	end

	local pattern = vim.bo.commentstring
	pattern = string.gsub(pattern, "%%s", ".*")
	pattern = string.gsub(pattern, "%-", "%%-")
	pattern = "^%s*" .. pattern .. "$"
	local line = vim.api.nvim_get_current_line()

	local match = string.match(line, pattern)

	if match then
		vim.cmd(string.format([['<,'>! boxes %s -s %s %s]], M.opts, indent, opts))
	else
		vim.cmd(string.format([['<,'>! boxes -r %s -s %s %s]], M.opts, indent, opts))
	end
end

function M.init()
	vim.keymap.set("v", "<leader>ib", ":lua require('boxes').enable()<cr>", {})
	vim.keymap.set("v", "<leader>iB", ":lua require('boxes').disable()<cr>", {})
end

M.init()

return M
