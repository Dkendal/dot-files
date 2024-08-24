local a = vim.api
local f = vim.fn
local command = a.nvim_create_user_command

local group = vim.api.nvim_create_augroup("user-commands", { clear = true })

a.nvim_create_autocmd({ "BufRead" }, {
	group = group,
	pattern = { "*.ejson" },
	callback = function()
		a.nvim_buf_create_user_command(0, "EjsonDecrypt", ":! ejson d % > %:r.json", {})
		a.nvim_buf_create_user_command(0, "EjsonEncrypt", ":! ejson e % && ejson d % > %:r.json", {})
	end,
})

command("Cd", function()
	local dir
	dir = vim.fn.expand("%:p")
	dir = vim.fn.finddir(".git", dir .. ";")
	dir = vim.fn.fnamemodify(dir, ":h")
	vim.api.nvim_set_current_dir(dir)
end, { force = true, desc = "Change root to nearest .git" })

command("TestNearest", function()
	require("neotest").run.run()
end, { force = true, desc = "" })

command("TestFile", function()
	require("neotest").run.run(f.expand("%"))
end, { force = true, desc = "" })

vim.cmd([[command! HiTest :so $VIMRUNTIME/syntax/hitest.vim]])

command("StripAnsiCodes", [[:%s/\e\[[0-9;]*m//g]], { force = true, desc = "Remove all ANSI codes" })

-- Abbreviations
vim.cmd([[cabbr bda Wipeout]])
vim.cmd([[cabbr V Verbose]])
vim.cmd([[cabbr H Helptags]])
vim.cmd([[cabbr <expr> R 'Rename '.expand('%:t')]])
vim.cmd([[cabbr <expr> @% expand('%')]])
vim.cmd([[cabbr <expr> @%p expand('%:p')]])
vim.cmd([[cnoreabbrev ~~ ~/code/github.com/Dkendal/]])

vim.cmd([[abbr overide override]])
vim.cmd([[abbr acount account]])
vim.cmd([[abbr resouces resources]])
vim.cmd([[abbr teh the]])
vim.cmd([[abbr <expr> d@ strftime('%Y-%m-%d')]])
vim.cmd([[abbr <expr> D@ strftime('%Y-%m-%d %a')]])
vim.cmd([[abbr <expr> ts@ strftime('%Y-%m-%d %a %k:%M')]])
vim.cmd([[abbr <expr> t@ strftime('%Y%m%d%k%M')]])
vim.cmd([[abbr <expr> us@ strftime('%s')]])

vim.cmd([[iabbr docu document]])
vim.cmd([[iabbr dont don't]])
vim.cmd([[iabbr dnt don't]])
vim.cmd([[iabbr abbr abbreviation]])
vim.cmd([[iabbr abbrs abbreviations]])
vim.cmd([[iabbr descr description]])
