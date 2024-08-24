local M = {}

local a = vim.api
local f = vim.fn

local state = {
	capture_messages = false,
}

local ns = a.nvim_create_namespace("user-jest")

local GruvBoxBg1 = a.nvim_get_hl_by_name("GruvBoxBg1", true)

local background = GruvBoxBg1.foreground

a.nvim_set_hl(0, "UserJestTestDefault", { background = background, italic = true })

a.nvim_set_hl(
	0,
	"UserJestTestDim",
	{ background = background, foreground = a.nvim_get_color_by_name("SlateGrey"), italic = true }
)

a.nvim_set_hl(
	0,
	"UserJestTestExpected",
	{ background = background, foreground = a.nvim_get_color_by_name("OrangeRed"), italic = true }
)
a.nvim_set_hl(

	0,
	"UserJestTestRecieved",
	{ background = background, foreground = a.nvim_get_color_by_name("PaleGreen"), italic = true }
)

local result_path = "/tmp/jest-results.json"

local ansi_to_hl = {
	default = "UserJestTestDefault",
	["2"] = "UserJestTestDim",
	["22"] = "UserJestTestDefault",
	["31"] = "UserJestTestExpected",
	["32"] = "UserJestTestRecieved",
	["39"] = "UserJestTestDefault",
}

local status_to_emojii = {
	["passed"] = "✅",
	["failed"] = "❌",
	["pending"] = "⏳",
	["skipped"] = "⚠️",
}

function M.update()
	vim.cmd([[ mes clear ]])
	if f.filereadable(result_path) == 0 then
		return
	end

	local data = f.json_decode(f.readfile(result_path))

	for _, result in ipairs(data.testResults) do
		---@type string
		local name = result.name
		local bufnr = f.bufnr(name)

		if bufnr ~= -1 then
			for _, assertion in ipairs(result.assertionResults) do
				-- vim.notify(vim.inspect(bufnr))

				local location = assertion.location

				if location ~= vim.NIL then
					---@type string[]
					local failure_messages = assertion.failureMessages
					---@type number
					local column = location.column
					---@type string
					local status = assertion.status
					---@type number
					local line = location.line

					local virt_lines = {}

					if state.capture_messages then
						for _, str in ipairs(failure_messages) do
							for line in string.gmatch(str, "([^\n]+)") do
								local line_tbl = {}

								local pattern = "\x1b%[([0-9;]*)m"
								local idx = 0
								local hl = ansi_to_hl.default
								local s, e, capture = string.find(line, pattern, idx)

								while s do
									table.insert(line_tbl, {
										string.sub(line, idx, s - 1),
										hl,
									})
									idx = e + 1
									hl = ansi_to_hl[capture] or capture
									s, e, capture = string.find(line, pattern, idx)
								end

								table.insert(virt_lines, line_tbl)
							end
						end

						-- filter out empty lines
						virt_lines = vim.tbl_filter(function(line)
							return #line > 0
						end, virt_lines)

						virt_lines = {}
					end

					a.nvim_buf_set_extmark(bufnr, ns, line - 1, column, {
						strict = false,
						virt_text = { { status_to_emojii[status] or status, "Normal" } },
						virt_text_pos = "eol",
						virt_lines = virt_lines,
					})
				end
			end
		end
	end
end

function M.open()
	if not f.filereadable(result_path) then
		vim.notify("file not readable: " .. result_path)
		return
	end

	local data = f.json_decode(f.readfile(result_path))

	local bufnr = f.bufadd("[jest-results]")

	local lines = {}

	a.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

	f.bufload(bufnr)
end

function M.setup()
	local group = a.nvim_create_augroup("user-jest", { clear = true })

	a.nvim_create_autocmd({ "BufEnter", "BufWrite", "CursorHold" }, {
		group = group,
		pattern = { "*.test.ts", "*.test.tsx", "*.test.js", "*.test.jsx" },
		callback = function(args)
			-- a.nvim_buf_create_user_command(args.buf, "JestOpen", M.open, {})
			a.nvim_buf_clear_namespace(args.buf, ns, 0, -1)

			M.update()
		end,
	})
end

M.setup()

return M
