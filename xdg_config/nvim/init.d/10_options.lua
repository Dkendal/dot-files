vim.g.mapleader = "<space>"
vim.g.localleader = "\\"

vim.cmd.filetype("plugin", "indent", "on")
vim.cmd.syntax("on")

vim.o.shell = "bash"
vim.o.cedit = "<C-O>"
vim.o.cinoptions = "1s,(0,W2,m1"
vim.o.makeef = "errors.err"
vim.o.clipboard = "unnamedplus,unnamed"
vim.o.grepprg = "rg --vimgrep"
vim.o.includeexpr = "asubstitute(v:fname,'[ab]/','./','g')"
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

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Folding
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldcolumn = "1"
vim.o.foldenable = true
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

vim.wo.number = true
vim.g.vimsyn_embed = "lmpPr"
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.netrw_banner = 0

