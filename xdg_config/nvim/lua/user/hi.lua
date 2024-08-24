-- DEPRECATED
local hsluv = require("vivid.hsluv.type")
local hsl = require("vivid.hsl.type")

local M = {}

---@class Highlight
---@field bg number
---@field fg number
---@field ctermbg number
---@field ctermfg number

---@param name string
---@return Highlight
function M.fetch_hl(name)
	local hl = vim.api.nvim_get_hl(0, { name = name })

	if vim.tbl_isempty(hl) then
		error("hi " .. name .. " not found")
	end

	return hl
end

---@param num number
---@return string
function M.to_hex(num)
	if not type(num) == "number" then
		error("num must be a number, got " .. type(num))
	end

	return string.format("#%06x", num)
end

function M.hsluv(color)
	local t = color

	if type(color) == "number" then
		t = M.to_hex(color)
	end

	return hsluv(t)
end

function M.get_color_by_name(name)
	return hsl(M.to_hex(vim.api.nvim_get_color_by_name(name)))
end

function M.hsl(color)
	return hsl(M.to_hex(color))
end

function M.get_hl(name)
	local hl = M.fetch_hl(name)
	local t = {}

	function t:bg()
		return M.hsluv(hl.bg)
	end

	function t:fg()
		return M.hsluv(hl.fg)
	end

	return t
end

function M.bg_hsluv(name)
	local hl = M.fetch_hl(name)
	return M.hsluv(hl.bg)
end

function M.fg_hsluv(name)
	local hl = M.fetch_hl(name)
	return M.hsluv(hl.fg)
end

function M.bg_hsl(name)
	local hl = M.fetch_hl(name)
	return M.hsluv(hl.fg)
end

function M.fg_hsl(name)
	local hl = M.fetch_hl(name)
	return M.hsluv(hl.fg)
end

function M.ansi_colors()
	local t = {}

	for i = 0, 15 do
		---@type string
		local value = vim.g["terminal_color_" .. i]

		if value then
			t[i] = hsl(value)
		end
	end

	return t
end

return M
