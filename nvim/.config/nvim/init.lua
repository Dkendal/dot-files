-- Set a specific node runtime to be the installation
-- let $PATH = $HOME.'/.asdf/installs/nodejs/14.15.5/bin:' . $PATH
-------------------------------------------------------------------------------
-- Bootstrap                                                                 --
-------------------------------------------------------------------------------
local fn = vim.fn
local cmd = vim.cmd
local autocmd = vim.api.nvim_create_autocmd

local init = {}
_G.init = init

local packer_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(packer_path)) > 0 then
	print("downloading packer.nvim...")
	fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path })
	print("downloading packer.nvim... done")
end

-------------------------------------------------------------------------------
-- Plugins                                                                   --
-------------------------------------------------------------------------------

local packer = require("packer")
local use = packer.use
local use_rocks = packer.use_rocks

packer.init({ ensure_dependencies = true })
packer.reset()

use_rocks({ "lua-toml", ft = { "toml" } })
use_rocks("penlight")
use_rocks("lpeg")

use({ "wbthomason/packer.nvim" })

use({ "tweekmonster/startuptime.vim", commands = { "StartupTime" } })

use({ "morhetz/gruvbox" })

use({ "rktjmp/lush.nvim" })

use({ "wlangstroth/vim-racket" })

use({ "fgsch/vim-varnish" })

use({ "neoclide/jsonc.vim" })

use({ ft = { "fennel" }, "bakpakin/fennel.vim" })

use({ ft = { "fish" }, "blankname/vim-fish" })

use({ ft = { "jsonnet" }, "google/vim-jsonnet" })

use({ "pld-linux/vim-syntax-vcl" })

use({ branch = "main", "earthly/earthly.vim" })

use({
	"elixir-editors/vim-elixir",
	ft = { "elixir", "eelixer" },
	config = function()
		vim.g.filetype_euphoria = "elixir"
		vim.g.elixir_use_markdown_for_docs = true
	end,
})

use({ "jparise/vim-graphql" })

use({
	"kristijanhusak/orgmode.nvim",
	config = function()
		require("orgmode"):setup({ org_agenda_files = { "~/notes/**/*" }, org_default_notes_file = "~/notes/gtd.org" })
	end,
})

use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

use({
	"nvim-telescope/telescope.nvim",
	requires = { { "nvim-lua/plenary.nvim" } },
	config = function()
		local mod = require("telescope")
		mod.setup({ extensions = { fzf = {} } })
		mod.load_extension("fzf")
	end,
})

use({ "junegunn/rainbow_parentheses.vim", ft = { "racket" } })

use({ "junegunn/vader.vim" })

use({ "rcarriga/vim-ultest" })

use({
	"vim-test/vim-test",
	config = function()
		vim.g["test#strategy"] = "neovim"
		vim.g["test#javascript#runner"] = "jest"
	end,
})

use({ "tpope/vim-commentary" })
use({ "tpope/vim-speeddating" })
use({ "tpope/vim-abolish" })
use({ "tpope/vim-eunuch" })
use({ "tpope/vim-fugitive" })
use({ "tpope/vim-repeat" })
use({ "tpope/vim-rhubarb" })
use({ "tpope/vim-rsi" })
use({ "tpope/vim-scriptease" })
use({ "tpope/vim-sleuth" })
use({ "tpope/vim-vinegar" })
use({ "tpope/vim-unimpaired" })

use({
	"simrat39/symbols-outline.nvim",
	config = function()
		vim.g.symbols_outline = {
			highlight_hovered_item = true,
			show_guides = true,
			auto_preview = true,
			position = "right",
			show_numbers = false,
			show_relative_numbers = false,
			show_symbol_details = true,
			keymaps = {
				close = "<Esc>",
				goto_location = "<Cr>",
				focus_location = "o",
				hover_symbol = "<C-space>",
				rename_symbol = "r",
				code_actions = "a",
			},
			lsp_blacklist = {},
		}
	end,
})

use({
	"glepnir/galaxyline.nvim",
	branch = "main",
	requires = "kyazdani42/nvim-web-devicons",
	config = function()
		return require("fnl.user.statusline")()
	end,
})

use({ "KabbAmine/vCoolor.vim" })
use({ "chrisbra/Colorizer" })
use({ "godlygeek/tabular" })
use({ "machakann/vim-sandwich" })
use({ "rstacruz/vim-closer" })
use({ "artnez/vim-wipeout" })
use({ "bogado/file-line" })
use({ "jamessan/vim-gnupg" })

-------------------------------------------------------------------------------
-- Formatter                                                                 --
-------------------------------------------------------------------------------
use({
	"mhartington/formatter.nvim",
	config = function()
		local formatter = require("formatter")

		local function package_json()
			-- FIXME not working
			local pkg_json = vim.fn.findfile("package.json", ".;")

			if pkg_json == nil or pkg_json == "" then
				return
			end

			local pkg = vim.fn.json_decode(vim.fn.readfile(pkg_json))

			if not pkg.scripts then
				return
			end
			if not pkg.scripts.fmt then
				return
			end

			return { exe = "yarn", args = { "run", "fmt" }, stdin = false }
		end

		local function whitespace()
			return { exe = "sed", args = { "-i", "'s/[ \9]*$//'" }, stdin = true }
		end

		local function shfmt()
			return { exe = "shfmt", args = {}, stdin = true }
		end

		local function mix()
			return { exe = "mix", args = { "format", "-" }, stdin = true }
		end

		local function fnlfmt()
			return { exe = "fnlfmt", args = { "-" }, stdin = true }
		end

		local function stylua()
			return {
				exe = "stylua",
				args = {
					"--indent-type",
					"Spaces",
					"--indent-width",
					"2",
				},
				stdin = false,
			}
		end

		local function prettier()
			return { exe = "prettier", args = { "--write" }, stdin = false }
		end

		local function raco_fmt()
			return { exe = "raco", args = { "fmt", "--width", 80 }, stdin = true }
		end

		local function jsbeautify()
			return {
				exe = "npx",
				args = { "js-beautify", "--end-with-newline", "--type", "html", "--file", "-" },
				stdin = true,
			}
		end

		local function jq()
			return { exe = "jq", args = { "'.'" }, stdin = true }
		end

		local function rufo()
			return { exe = "rufo", args = {}, stdin = false }
		end

		local function buildifier()
			return { exe = "buildifier", args = {}, stdin = false }
		end

		local function pg_format()
			return { exe = "pg_format", args = {}, stdin = true }
		end

		formatter.setup({
			logging = true,
			filetype = {
				["*"] = { whitespace },
				sql = { pg_format },
				sh = { shfmt },
				bash = { shfmt },
				ruby = { rufo },
				elixir = { mix },
				eelixir = { jsbeautify },
				bzl = { buildifier },
				fennel = { fnlfmt },
				lua = { stylua },
				racket = { raco_fmt },
				json = { jq },
				jsonc = { jq },
				javascript = {
					function()
						return (package_json() or prettier())
					end,
				},
				yaml = { prettier },
				markdown = {
					function()
						return (package_json() or prettier())
					end,
				},
				html = { prettier },
				typescript = {
					function()
						return (package_json() or prettier())
					end,
				},
				javascriptreact = {
					function()
						return (package_json() or prettier())
					end,
				},
				typescriptreact = {
					function()
						return (package_json() or prettier())
					end,
				},
			},
		})
	end,
})

use({ "chrisbra/NrrwRgn" })
use({ "ryanoasis/vim-devicons" })
use({ "kyazdani42/nvim-web-devicons" })
use({ "onsails/lspkind-nvim" })

-------------------------------------------------------------------------------
-- Snippets                                                                  --
-------------------------------------------------------------------------------

use({ "L3MON4D3/LuaSnip" })

-------------------------------------------------------------------------------
-- CMP Plugins                                                               --
-------------------------------------------------------------------------------
use({ "hrsh7th/cmp-nvim-lsp" })
use({ "hrsh7th/cmp-buffer" })
use({ "hrsh7th/cmp-path" })
use({ "saadparwaiz1/cmp_luasnip" })
use({ "hrsh7th/cmp-nvim-lua" })
use({ "hrsh7th/cmp-calc" })
use({ "hrsh7th/cmp-emoji" })

-------------------------------------------------------------------------------
-- CMP
-------------------------------------------------------------------------------
use("hrsh7th/nvim-cmp")

use({ "nvim-lua/lsp-status.nvim" })

use({
	requires = "kyazdani42/nvim-web-devicons",
	config = function()
		require("trouble").setup()
	end,
	"folke/trouble.nvim",
})

use({
	config = function()
		local zen_mode = require("zen-mode")
		return zen_mode.setup({ dimming = { alpha = 0.4 } })
	end,
	"folke/zen-mode.nvim",
})

use({
	config = function()
		local twilight = require("twilight")
		return twilight.setup({ dimming = { alpha = 0.4 } })
	end,
	"folke/twilight.nvim",
})

use("folke/which-key.nvim")

-------------------------------------------------------------------------------
-- LSP Configuration                                                         --
-------------------------------------------------------------------------------
use({ "jose-elias-alvarez/null-ls.nvim" })

use({
	requires = { "lsp-status.nvim" },
	"neovim/nvim-lspconfig",
})

-------------------------------------------------------------------------------
-- Treesitter                                                                --
-------------------------------------------------------------------------------
use({
	run = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")

		local setup = config["setup"]

		local parser_config = require("nvim-treesitter.parsers"):get_parser_configs()

		parser_config.org = {
			filetype = "org",
			install_info = { url = "https://github.com/milisims/tree-sitter-org", revision = "main" },
		}
		parser_config.markdown = {
			filetype = "markdown",
			install_info = {
				url = "https://github.com/MDeiml/tree-sitter-markdown",
				files = { "src/parser.c", "src/scanner.cc" },
				revision = "main",
			},
		}

		setup({
			ensure_installed = {},
			treeclimber = { enable = true },
			query_linter = { enable = true, use_virtual_text = true, lint_events = { "BufWrite", "CursorHold" } },
			textsubjects = {
				enable = true,
				prev_selection = ",", -- (Optional) keymap to select the previous selection
				keymaps = {
					["."] = "textsubjects-smart",
					[";"] = "textsubjects-container-outer",
					["i;"] = "textsubjects-container-inner",
				},
			},
			playground = {
				enable = true,
				disable = {},
				updatetime = 25,
				persist_queries = false,
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = t("<leader>v"),
					node_incremental = "<M-n>",
					scope_incremental = "<M-N>",
					node_decremental = "<M-p>",
				},
			},
			indent = { enable = true },
			refactor = {
				highlight_definitions = { enable = true },
				highlight_current_scope = { enable = false },
				smart_rename = { enable = true, keymaps = { smart_rename = "<leader>rr" } },
			},
			highlight = {
				enable = true,
				disable = { "org" },
				additional_vim_regex_highlighting = { "org" },
				custom_captures = {},
			},
			rainbow = { enable = true, extended_mode = true },
		})
	end,

	"nvim-treesitter/nvim-treesitter",
})

use({ commands = { "tsplaygroundtoggle", "tshighlightcapturesundercursor" }, "nvim-treesitter/playground" })

use({ "nvim-treesitter/nvim-treesitter-textobjects" })

use({ "rrethy/nvim-treesitter-textsubjects" })

use({ before = { "nvim-treesitter/nvim-treesitter" }, "p00f/nvim-ts-rainbow" })
use({
	config = function()
		vim.g.user_emmet_leader_key = "<c-y>"
	end,
	"mattn/emmet-vim",
})

use({
	branch = "master",
	config = function()
		vim.g.vm_theme = "paper"
	end,
	"mg979/vim-visual-multi",
})

use({
	branch = "master",
	config = function()
		vim.g.indent_blankline_use_treesitter = true
		vim.g.indent_blankline_show_current_context = true
		vim.g.indent_blankline_char_list = { "\226\148\131" }
		vim.g.indent_blankline_filetype_exclude = { "help" }
	end,

	"lukas-reineke/indent-blankline.nvim",
})

use({
	requires = { "nvim-lua/plenary.nvim" },
	tag = "v0.2",
	config = function()
		local gitsigns = require("gitsigns")
		return gitsigns.setup({
			watch_index = { interval = 1000 },
			signs = {
				add = { hl = "GitSignsAdd", text = "\226\148\130", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
				change = {
					hl = "GitSignsChange",
					text = "\226\148\130",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
				delete = {
					hl = "GitSignsDelete",
					text = "_",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn",
				},
				topdelete = {
					hl = "GitSignsDelete",
					text = "\226\128\190",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn",
				},
				changedelete = {
					hl = "GitSignsChange",
					text = "~",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
			},
		})
	end,
	"lewis6991/gitsigns.nvim",
})

use({ run = ":ghostinstall", "raghur/vim-ghost" })

use({ run = "./install --all", "junegunn/fzf" })

use({ requires = { "junegunn/fzf" }, "junegunn/fzf.vim" })

use({ commit = "3a08f00", frozen = true, "vijaymarupudi/nvim-fzf" })

use({
	config = function()
		local fidget = require("fidget")
		return fidget.setup({})
	end,
	"j-hui/fidget.nvim",
})

use({ "ggandor/lightspeed.nvim" })

use({ "AndrewRadev/splitjoin.vim" })

vim.cmd("packadd! cfilter")
vim.cmd("packadd! matchit")
vim.cmd("packadd! nvim-gh")
vim.cmd("packadd! nvim-viper")
vim.cmd("packadd! nvim-treeclimber")

require("gh").setup()
require("nvim-treeclimber").setup()

-- Options
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

vim.o.shell = "bash"
vim.o.cedit = "<C-O>"
vim.o.cinoptions = "1s,(0,W2,m1"
vim.o.makeef = "errors.err"
vim.o.clipboard = "unnamedplus,unnamed"
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99
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

-- Tree sitter folding
vim.o.foldmethod = "expr"
vim.cmd([[set foldexpr=nvim_treesitter#foldexpr()]])

vim.wo.number = true
vim.g.vimsyn_embed = "lmpPr"
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Commands
vim.cmd([[command! -nargs=1 Fnl :lua print(vim.inspect(require('fennel').eval(<f-args>)))]])
vim.cmd([[command! HiTest :so $VIMRUNTIME/syntax/hitest.vim]])

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

local hooks = require("user.hooks")

hooks.register("colorscheme", function()
	local lush = require("lush")
	local hl = require("user.hl")

	local Normal = hl.get_hl("Normal")
	local SignColumn = hl.get_hl("SignColumn")
	local bg = lush.hsluv(Normal.background).lighten(8)

	vim.cmd([[hi! link LspDiagnosticsDefaultHint GruvboxBg4]])
	vim.cmd([[hi Comment gui=italic cterm=italic]])
	vim.cmd([[hi NormalFloat guibg=]] .. bg)
	vim.cmd([[hi FloatBorder guifg=white guibg=]] .. bg)
	vim.cmd([[hi DiagnosticSignError guibg=]] .. SignColumn.background)
	vim.cmd([[hi DiagnosticSignInfo guibg=]] .. SignColumn.background)
	vim.cmd([[hi DiagnosticSignWarn guibg=]] .. SignColumn.background)
	vim.cmd([[hi DiagnosticSignOther guibg=]] .. SignColumn.background)
	vim.cmd([[hi DiagnosticSignHint guibg=]] .. SignColumn.background)

	require("fnl.user.statusline")()
end)

hooks.register("after-init", function() end)

vim.cmd([[augroup user]])
vim.cmd([[au!]])
hooks.install_autocommand("colorscheme", "ColorScheme *")

if vim.v.vim_did_enter == 1 then
	hooks.run("after-init")
else
	cmd([[au SourcePost ++once packer_compiled.vim lua require("user.hooks").run('after-init')]])
end

vim.cmd([[augroup END]])

vim.cmd([[runtime macros/sandwich/keymap/surround.vim]])

require("globals")

-------------------------------------------------------------------------------
-- Filetypes                                                                 --
-------------------------------------------------------------------------------

vim.g.do_filetype_lua = 1

vim.filetype.add({
	extensions = { rkt = "racket" },
	filename = { WORKSPACE = "bzl", BUILD = "bzl", Earthfile = "Earthfile" },
})

-------------------------------------------------------------------------------
-- Snippets                                                                  --
-------------------------------------------------------------------------------
-- map("v", "<C-f>", [["ec<cmd>lua require('luasnip.extras.otf').on_the_fly()<cr>]])
-- map("i", "<C-f>", [[<cmd>lua require('luasnip.extras.otf').on_the_fly("e")<cr>]])

require("boxes")
require("background")

vim.g.gruvbox_contrast_dark = "hard"
vim.cmd("colorscheme gruvbox")

vim.o.exrc = true
vim.o.secure = true
