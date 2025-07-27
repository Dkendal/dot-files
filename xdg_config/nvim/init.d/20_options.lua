vim.o.shell = "bash"
vim.o.cedit = "<C-O>"
vim.o.cinoptions = "1s,(0,W2,m1"
vim.o.makeef = "errors.err"
vim.o.clipboard = "unnamedplus,unnamed"
vim.o.grepprg = "rg --vimgrep"
vim.o.conceallevel = 3
-- vim.o.includeexpr = function(fname)
-- 	return string.gsub(fname, [[[ab]/]], [[./]])
-- end
vim.o.hidden = true
vim.o.timeoutlen = 400
vim.o.showbreak = "\226\134\179"
vim.o.wrap = false
vim.o.breakindent = true
vim.o.colorcolumn = "80"
vim.o.list = true
vim.o.mouse = "a"
vim.o.synmaxcol = 3000
vim.o.undofile = true
vim.o.backup = true
vim.o.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.o.wildignorecase = true
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
vim.o.expandtab = true
vim.o.lazyredraw = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.incsearch = true
vim.o.magic = true
vim.o.smartcase = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.completeopt = "menu,menuone,noselect"
vim.o.signcolumn = "yes:1"
vim.o.cp = false
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.encoding = "UTF-8"
vim.o.ttimeoutlen = 10

vim.o.shortmess = vim.fn.join({
	"A", -- Don't give the "ATTENTION" message when an existing	*shm-A*
	"C", -- Don't give messages about scanning included files when completing
	"F", -- Don't give the file info when editing a file (like number of lines and name)
	"O", -- Message for reading a file overwrites any previous message
	"T", -- Truncate other messages in the middle if too long
	"c", -- Don't give "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
	"l", -- Don't give "search hit BOTTOM, continuing at TOP" or similar messages
	"o", -- Overwrite message for writing a file with subsequent message
	"t", -- Truncate file messages at the start if too long
}, "")

-- Folding
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldcolumn = "1"
vim.o.foldenable = true

vim.o.number = true
