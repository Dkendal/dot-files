local M = {}
local v = vim.fn
local api = vim.api

local diagnostic = require("galaxyline.provider_diagnostic")
local vcs = require("galaxyline.provider_vcs")
local fileinfo = require("galaxyline.provider_fileinfo")
local extension = require("galaxyline.provider_extensions")
local buffer = require("galaxyline.provider_buffer")
local whitespace = require("galaxyline.provider_whitespace")
local lspclient = require("galaxyline.provider_lsp")
local lsp_status = require("lsp-status")
local condition = require("galaxyline.condition")
local colors = (require("galaxyline.theme")).default

local BufferIcon = buffer.get_buffer_type_icon
local BufferNumber = buffer.get_buffer_number
local FileTypeName = buffer.get_buffer_filetype
local GitBranch = vcs.get_git_branch
local DiffAdd = vcs.diff_add
local DiffModified = vcs.diff_modified
local DiffRemove = vcs.diff_remove
local LineColumn = fileinfo.line_column
local FileFormat = fileinfo.get_file_format
local FileEncode = fileinfo.get_file_encode
local FileSize = fileinfo.get_file_size
local FileIcon = fileinfo.get_file_icon
local FileName = fileinfo.get_current_file_name
local LinePercent = fileinfo.current_line_percent
local ScrollBar = extension.scrollbar_instance
local VistaPlugin = extension.vista_nearest
local Whitespace = whitespace.get_item
local DiagnosticError = diagnostic.get_diagnostic_error
local DiagnosticWarn = diagnostic.get_diagnostic_warn
local DiagnosticHint = diagnostic.get_diagnostic_hint
local DiagnosticInfo = diagnostic.get_diagnostic_info
local GetLspClient = lspclient.get_lsp_client

local function Recording()
	local reg = vim.fn.reg_recording()
	if reg == "" then
		return nil
	else
		return "recording @" .. reg
	end
end

local function SearchCount()
	local c = vim.fn.searchcount({ recompute = false })

	if vim.v.hlsearch == 0 then
		return nil
	end

	if c.incomplete == 1 then
		return "[?/??]"
	end

	if c.incomplete == 2 then
		if c.total > c.maxcount and c.current > c.maxcount then
			return string.format("[>%d/%d]", c.current, c.total)
		end
		if c.total > c.maxcount then
			return string.format("[%d/>%d]", c.current, c.total)
		end
	end

	return string.format("[%d/%d]", c.current, c.total)
end

local function LspStatus()
	if #vim.lsp.buf_get_clients() > 0 then
		return lsp_status.status()
	else
		return nil
	end
end

local function cursor()
	return string.format("%d:%d", v.line("."), v.col("."))
end

local function filename()
	return v.fnamemodify(v.expand("%"), ":t")
end

local function hi_attr(name, _3fattr)
	return function()
		return v.synIDattr(v.hlID(name), (_3fattr or "fg"))
	end
end

local function hi(name)
	local id = v.hlID(name)
	local mode = "gui"
	return { fg = v.synIDattr(id, "fg", mode), bg = v.synIDattr(id, "bg", mode) }
end

local sep = {
	["pyramid-right"] = "\238\130\176",
	["pyramid-empty-right"] = "\238\130\177",
	["pyramid-left"] = "\238\130\178",
	["pyramid-empty-left"] = "\238\130\179",
	["semi-sphere-right"] = "\238\130\180",
	["semi-sphere-empty-right"] = "\238\130\181",
	["semi-sphere-left"] = "\238\130\182",
	["semi-sphere-empty-left"] = "\238\130\183",
	["tri-up-left"] = "\238\130\184",
	["slash-left"] = "\238\130\185",
	["tri-up-right"] = "\238\130\186",
	["slash-right"] = "\238\130\187",
	["tri-down-left"] = "\238\130\188",
	["tri-down-right"] = "\238\130\190",
	space = " ",
}

local colors0 = {
	fg = hi_attr("normal", "fg"),
	bg = hi_attr("normal", "bg"),
	fg0 = hi_attr("GruvboxFg0"),
	fg1 = hi_attr("GruvboxFg1"),
	fg2 = hi_attr("GruvboxFg2"),
	fg3 = hi_attr("GruvboxFg3"),
	fg4 = hi_attr("GruvboxFg4"),
	bg0 = hi_attr("GruvboxBg0"),
	bg1 = hi_attr("GruvboxBg1"),
	bg2 = hi_attr("GruvboxBg2"),
	bg3 = hi_attr("GruvboxBg3"),
	bg4 = hi_attr("GruvboxBg4"),
	purple = hi_attr("GruvboxPurple", "fg"),
	blue = hi_attr("GruvboxBlue", "fg"),
	normal = hi("normal"),
	StatusLine = hi("StatusLineNC"),
}

local function theme(group0)
	local color_ = { colors0.fg3, colors0.bg1 }

	return vim.tbl_extend("keep", group0, { highlight = color_, separator = sep.space, separator_highlight = color_ })
end

function M.init()
	local gl = require("galaxyline")
	local section = gl.section

	local group = vim.api.nvim_create_augroup("UserStatusline", { clear = true })

	-- Update the search count when the the cursor moves
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = group,
		pattern = "*",
		callback = function()
			vim.defer_fn(function()
				vim.fn.searchcount({ recompute = true, maxcount = 0, timeout = 100 })
				vim.cmd.redrawstatus()
			end, 200)
		end,
	})

	section["left"] = {
		{ FileIcon = theme({ provider = FileIcon }) },
		{ FilePath = theme({ provider = filename }) },
		{ LineColumn = theme({ provider = cursor }) },
		{ LinePercent = theme({ provider = LinePercent }) },
	}

	section["right"] = {
		{ SearchCount = theme({ provider = SearchCount }) },
		{ Recording = theme({ provider = Recording }) },
		{ LspStatus = theme({ provider = LspStatus }) },
	}

	vim.o.winbar = "%#StatusLineNC#%=%m %f"
end

return M
