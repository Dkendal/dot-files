local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local F = require("strings").interpolate

local Boxes = {}

Boxes.ft_opts = {
	toml = "-d shell",
	Earthfile = "-d shell",
	yaml = "-d shell",
	lua = "-d ada-box",
	fennel = "-d lisp",
	elixir = "-d shell",
}

Boxes.opts = [[]]

function Boxes.enable()
	local ft = vim.bo.filetype
	local indent = 79 - fn.indent(".")

	local opts = Boxes.ft_opts[ft]

	if not opts then
		opts = ""
	end

	cmd(
		F(
			[['<,'>!boxes ${shared_opts} -s ${indent} ${opts}]],
			{ indent = indent, opts = opts, shared_opts = Boxes.opts }
		)
	)
end

function Boxes.disable()
	local ft = vim.bo.filetype
	local indent = 79 - fn.indent(".")

	local opts = Boxes.ft_opts[ft]

	if not opts then
		opts = ""
	end

	local vars = { indent = indent, opts = opts, shared_opts = Boxes.opts }
	cmd(F([['<,'>!boxes -r ${shared_opts} -s ${indent} ${opts}]], vars))
end

function Boxes.init()
	api.nvim_set_keymap("v", "<space>ib", [[:lua require("boxes").enable()<cr>]], {})
	api.nvim_set_keymap("v", "<space>iB", [[:lua require("boxes").disable()<cr>]], {})
end

Boxes.init()

return Boxes
