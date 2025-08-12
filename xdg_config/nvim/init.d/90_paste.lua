local uri = require("user.parsers.uri")
local email = require("user.parsers.email")
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

if not _G['original.vim.paste'] then
	_G['original.vim.paste'] = vim.paste
end

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

local function norg_paste(lines)
	for i, line in ipairs(lines) do
		local trimmed_line = vim.trim(line)
		if is_image_path(trimmed_line) then
			local relative_path = vim.fn.fnamemodify(trimmed_line, ":p:~")
			lines[i] = ".image " .. relative_path
		end
	end
end


local function org_paste(lines)
	return vim.iter(lines)
			:map(function(line)
				if is_image_path(line) then
					local path = vim.fn.fnamemodify(line, ":p:~")
					return ("[[%s]]"):format(path)
				end

				-- Use gsub to process non-boundary sequences
				local result = line:gsub("([^%s,;|]+)", function(str)
					local parsed_uri = uri.parse_uri(str)

					if parsed_uri then
						-- Atlassian urls (Jira and Confluence)
						if parsed_uri.host and parsed_uri.host:match("%.atlassian%.net$") then
							-- Jira urls
							local issue_key = parsed_uri.path and parsed_uri.path:match("/browse/([A-Z]+%-[0-9]+)")
							if issue_key then
								return ("[[%s][%s]]"):format(str, issue_key)
							end

							-- Confluence urls
							local confluence_match = parsed_uri.path and parsed_uri.path:match("/wiki/spaces/[^/]+/pages/[0-9]+/(.+)$")
							if confluence_match then
								-- Decode URL encoding (e.g., + to space)
								local title = confluence_match:gsub("+", " ")
								-- Basic URL decode for common characters
								title = title:gsub("%%20", " ")
								title = title:gsub("%%2B", "+")
								title = title:gsub("%%2D", "-")
								return ("[[%s][Confluence: %s 🔗]]"):format(str, title)
							end
						end

						return ("[[%s][%s 🔗]]"):format(str, parsed_uri.host)
					end

					local parsed_emails = email.parse_emails(str)
					if #parsed_emails > 0 then
						local parsed_email = parsed_emails[1]
						return ("[[people:%s][%s]]"):format(parsed_email.local_part, parsed_email.full)
					end

					return str
				end)

				return result
			end)
			:totable()
end

local function paste(lines, phase)
	local filetype = vim.bo.filetype

	if filetype == "norg" then
		return norg_paste(lines)
	end

	if filetype == "org" then
		return org_paste(lines)
	end

	return lines
end

vim.paste = function(lines, phase)
	return _G['original.vim.paste'](paste(lines, phase), phase)
end
