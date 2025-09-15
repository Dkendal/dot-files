local function copy_buffer_path_with_lines(opts)
	-- Get the current buffer's file path
	local buffer_path

	-- Check if bang is present to determine path type
	if opts.bang then
		-- Bang present: use absolute path
		buffer_path = vim.fn.expand("%:p")
	else
		-- No bang: use relative path from current working directory
		buffer_path = vim.fn.expand("%:.")
	end

	-- If buffer has no file path, use buffer name or indicate it's unnamed
	if buffer_path == "" then
		buffer_path = vim.fn.expand("%") -- Try buffer name
		if buffer_path == "" then
			buffer_path = "[No Name]"
		end
	end

	local line_info = ""

	-- Check if command was called with a range
	if opts.range and opts.range > 0 then
		local start_line = opts.line1
		local end_line = opts.line2

		if start_line == end_line then
			line_info = ":" .. start_line
		else
			line_info = ":" .. start_line .. "-" .. end_line
		end
	else
		local mode = vim.fn.mode()

		-- Check if we're in visual mode (visual, visual-line, or visual-block)
		local visual_modes = { v = true, V = true, ["\22"] = true } -- \22 is Ctrl-V (visual block mode)
		if visual_modes[mode] then
			-- Get visual selection range
			local start_line = vim.fn.line("'<")
			local end_line = vim.fn.line("'>")

			if start_line == end_line then
				line_info = ":" .. start_line
			else
				line_info = ":" .. start_line .. "-" .. end_line
			end
		else
			-- Get current line number
			local current_line = vim.fn.line(".")
			line_info = ":" .. current_line
		end
	end

	local result = buffer_path .. line_info

	-- Copy to system clipboard with error handling
	local success = pcall(vim.fn.setreg, "+", result)
	if not success then
		print("Warning: Failed to copy to system clipboard")
	end

	-- Also copy to unnamed register as backup
	vim.fn.setreg('"', result)
end

return copy_buffer_path_with_lines
