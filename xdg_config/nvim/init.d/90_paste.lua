--[[
--------------------------------------------------
-- Enhanced Paste Handler for Neovim
--------------------------------------------------
-- This module overrides Neovim's default paste behavior to add
-- special handling for Neorg files. When pasting image file paths
-- into a Neorg file, it automatically converts them to the proper
-- Neorg image syntax (.image) with relative paths.
--
-- Features:
--   - Detects image file paths during paste operations
--   - Converts absolute paths to relative paths
--   - Automatically prepends .image for Neorg files
--   - Preserves default paste behavior for all other cases
--
-- Date: 2025-06-18
--]]

local original = vim.paste

-- Helper function to check if a string is an image path
local function is_image_path(text)
	local image_extensions = { "png", "jpg", "jpeg", "gif", "bmp", "webp", "svg", "tiff", "ico" }
	local trimmed = vim.trim(text)

	-- Check if it looks like a file path (contains path separators)
	if not (trimmed:match("/") or trimmed:match("\\")) then
		return false
	end

	-- Check if it ends with an image extension
	local extension = trimmed:match("%.(%w+)$")
	if extension then
		extension = extension:lower()
		for _, ext in ipairs(image_extensions) do
			if extension == ext then
				return true
			end
		end
	end

	return false
end

vim.paste = function(lines, phase)
	-- Check if we're in a norg file
	local filetype = vim.bo.filetype

	if filetype == "norg" and phase == -1 then
		-- Process each line
		for i, line in ipairs(lines) do
			local trimmed_line = vim.trim(line)
			if is_image_path(trimmed_line) then
				-- Convert to relative path and add .image prefix
				vim.notify(trimmed_line)
				local relative_path = vim.fn.fnamemodify(trimmed_line, ":p:~")
				lines[i] = ".image " .. relative_path
			end
		end
	end

	-- Call the original paste function with potentially modified lines
	return original(lines, phase)
end
