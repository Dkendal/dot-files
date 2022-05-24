-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/dylan/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/dylan/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/dylan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/dylan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/dylan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  Colorizer = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/Colorizer",
    url = "https://github.com/chrisbra/Colorizer"
  },
  LuaSnip = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  NrrwRgn = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/NrrwRgn",
    url = "https://github.com/chrisbra/NrrwRgn"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-calc"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/cmp-calc",
    url = "https://github.com/hrsh7th/cmp-calc"
  },
  ["cmp-emoji"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["earthly.vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/earthly.vim",
    url = "https://github.com/earthly/earthly.vim"
  },
  ["emmet-vim"] = {
    config = { "\27LJ\2\n=\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\n<c-y>\26user_emmet_leader_key\6g\bvim\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  ["fennel.vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/opt/fennel.vim",
    url = "https://github.com/bakpakin/fennel.vim"
  },
  ["fidget.nvim"] = {
    config = { "\27LJ\2\n4\0\0\4\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\1\2\0004\3\0\0D\1\2\0\nsetup\vfidget\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["file-line"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/file-line",
    url = "https://github.com/bogado/file-line"
  },
  fzf = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n≤\4\0\0\6\0\18\0\0206\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0035\4\a\0005\5\6\0=\5\b\0045\5\t\0=\5\n\0045\5\v\0=\5\f\0045\5\r\0=\5\14\0045\5\15\0=\5\16\4=\4\17\3D\1\2\0\nsigns\17changedelete\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\6~\vlinehl\21GitSignsChangeLn\14topdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\b‚Äæ\vlinehl\21GitSignsDeleteLn\vdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\6_\vlinehl\21GitSignsDeleteLn\vchange\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\b‚îÇ\vlinehl\21GitSignsChangeLn\badd\1\0\0\1\0\4\ahl\16GitSignsAdd\nnumhl\18GitSignsAddNr\ttext\b‚îÇ\vlinehl\18GitSignsAddLn\16watch_index\1\0\0\1\0\1\rinterval\3Ë\a\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  gruvbox = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/gruvbox",
    url = "https://github.com/morhetz/gruvbox"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\nÂ\1\0\0\2\0\b\0\0176\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0K\0\1\0\1\2\0\0\thelp&indent_blankline_filetype_exclude\1\2\0\0\b‚îÉ\31indent_blankline_char_list*indent_blankline_show_current_context$indent_blankline_use_treesitter\6g\bvim\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["jsonc.vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/jsonc.vim",
    url = "https://github.com/neoclide/jsonc.vim"
  },
  ["lightspeed.nvim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/lightspeed.nvim",
    url = "https://github.com/ggandor/lightspeed.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/lsp-status.nvim",
    url = "https://github.com/nvim-lua/lsp-status.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/lush.nvim",
    url = "https://github.com/rktjmp/lush.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-fzf"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-fzf",
    url = "https://github.com/vijaymarupudi/nvim-fzf"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n⁄\n\0\0\v\0002\0@6\0\0\0'\2\1\0B\0\2\0029\1\2\0006\2\0\0'\4\3\0B\2\2\2\18\4\2\0009\2\4\2B\2\2\0025\3\6\0005\4\a\0005\5\b\0=\5\t\4=\4\n\3=\3\5\2\18\3\1\0005\5\v\0004\6\0\0=\6\f\0055\6\r\0=\6\14\0055\6\15\0005\a\16\0=\a\17\6=\6\18\0055\6\19\0005\a\20\0=\a\21\6=\6\22\0055\6\23\0004\a\0\0=\a\24\0065\a\25\0=\a\26\6=\6\27\0055\6\28\0005\a\31\0006\b\29\0'\n\30\0B\b\2\2=\b \a=\a\21\6=\6!\0055\6\"\0=\6#\0055\6%\0005\a$\0=\a&\0065\a'\0=\a(\0065\a)\0005\b*\0=\b\21\a=\a+\6=\6,\0055\6-\0004\a\0\0=\a.\6=\6/\0055\0060\0=\0061\5B\3\2\1K\0\1\0\frainbow\1\0\2\venable\2\18extended_mode\2\14highlight\20custom_captures\1\0\1\venable\2\rrefactor\17smart_rename\1\0\1\17smart_rename\15<leader>rr\1\0\1\venable\2\28highlight_current_scope\1\0\1\venable\1\26highlight_definitions\1\0\0\1\0\1\venable\2\vindent\1\0\1\venable\2\26incremental_selection\19init_selection\1\0\3\22scope_incremental\n<M-N>\21node_decremental\n<M-p>\21node_incremental\n<M-n>\14<leader>v\6t\1\0\1\venable\2\15playground\16keybindings\1\0\n\27toggle_anonymous_nodes\6a\30toggle_injected_languages\6t\21toggle_hl_groups\6i\24toggle_query_editor\6o\14show_help\6?\14goto_node\t<cr>\vupdate\6R\21unfocus_language\6F\19focus_language\6f\28toggle_language_display\6I\fdisable\1\0\3\venable\2\15updatetime\3\25\20persist_queries\1\17textsubjects\fkeymaps\1\0\3\6.\23textsubjects-smart\ai;!textsubjects-container-inner\6;!textsubjects-container-outer\1\0\2\venable\2\19prev_selection\6,\17query_linter\16lint_events\1\3\0\0\rBufWrite\15CursorHold\1\0\2\venable\2\21use_virtual_text\2\16treeclimber\1\0\1\venable\2\21ensure_installed\1\0\0\17install_info\nfiles\1\3\0\0\17src/parser.c\19src/scanner.cc\1\0\2\burl3https://github.com/MDeiml/tree-sitter-markdown\rrevision\tmain\1\0\1\rfiletype\rmarkdown\rmarkdown\23get_parser_configs\28nvim-treesitter.parsers\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-treesitter-textsubjects"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textsubjects",
    url = "https://github.com/rrethy/nvim-treesitter-textsubjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["refactoring.nvim"] = {
    config = { "\27LJ\2\nn\0\0\3\0\5\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0016\0\0\0'\2\3\0B\0\2\0029\0\4\0'\2\1\0B\0\2\1K\0\1\0\19load_extension\14telescope\nsetup\16refactoring\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/refactoring.nvim",
    url = "https://github.com/ThePrimeagen/refactoring.nvim"
  },
  ["splitjoin.vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/splitjoin.vim",
    url = "https://github.com/AndrewRadev/splitjoin.vim"
  },
  ["startuptime.vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/startuptime.vim",
    url = "https://github.com/tweekmonster/startuptime.vim"
  },
  ["symbols-outline.nvim"] = {
    config = { "\27LJ\2\nø\2\0\0\3\0\a\0\t6\0\0\0009\0\1\0005\1\3\0005\2\4\0=\2\5\0014\2\0\0=\2\6\1=\1\2\0K\0\1\0\18lsp_blacklist\fkeymaps\1\0\6\17code_actions\6a\nclose\n<Esc>\18rename_symbol\6r\17hover_symbol\14<C-space>\19focus_location\6o\18goto_location\t<Cr>\1\0\a\24show_symbol_details\2\26show_relative_numbers\1\17show_numbers\1\rposition\nright\17auto_preview\2\16show_guides\2\27highlight_hovered_item\2\20symbols_outline\6g\bvim\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/symbols-outline.nvim",
    url = "https://github.com/simrat39/symbols-outline.nvim"
  },
  tabular = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/tabular",
    url = "https://github.com/godlygeek/tabular"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n{\0\0\6\0\b\0\0146\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\5\0005\4\3\0004\5\0\0=\5\4\4=\4\6\3B\1\2\0019\1\a\0'\3\4\0B\1\2\1K\0\1\0\19load_extension\15extensions\1\0\0\bfzf\1\0\0\nsetup\14telescope\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["twilight.nvim"] = {
    config = { "\27LJ\2\n]\0\0\5\0\6\0\b6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3D\1\2\0\fdimming\1\0\0\1\0\1\nalpha\4ö≥ÊÃ\tô≥Ê˛\3\nsetup\rtwilight\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/twilight.nvim",
    url = "https://github.com/folke/twilight.nvim"
  },
  ["vCoolor.vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vCoolor.vim",
    url = "https://github.com/KabbAmine/vCoolor.vim"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-abolish",
    url = "https://github.com/tpope/vim-abolish"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
  },
  ["vim-elixir"] = {
    config = { "\27LJ\2\ng\0\0\2\0\5\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\4\0K\0\1\0!elixir_use_markdown_for_docs\velixir\22filetype_euphoria\6g\bvim\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/opt/vim-elixir",
    url = "https://github.com/elixir-editors/vim-elixir"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-eunuch",
    url = "https://github.com/tpope/vim-eunuch"
  },
  ["vim-fish"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/opt/vim-fish",
    url = "https://github.com/blankname/vim-fish"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-gnupg"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-gnupg",
    url = "https://github.com/jamessan/vim-gnupg"
  },
  ["vim-jsonnet"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/opt/vim-jsonnet",
    url = "https://github.com/google/vim-jsonnet"
  },
  ["vim-racket"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-racket",
    url = "https://github.com/wlangstroth/vim-racket"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-rhubarb",
    url = "https://github.com/tpope/vim-rhubarb"
  },
  ["vim-rsi"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-rsi",
    url = "https://github.com/tpope/vim-rsi"
  },
  ["vim-sandwich"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-sandwich",
    url = "https://github.com/machakann/vim-sandwich"
  },
  ["vim-scriptease"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-scriptease",
    url = "https://github.com/tpope/vim-scriptease"
  },
  ["vim-sleuth"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-sleuth",
    url = "https://github.com/tpope/vim-sleuth"
  },
  ["vim-speeddating"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-speeddating",
    url = "https://github.com/tpope/vim-speeddating"
  },
  ["vim-syntax-vcl"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-syntax-vcl",
    url = "https://github.com/pld-linux/vim-syntax-vcl"
  },
  ["vim-test"] = {
    config = { "\27LJ\2\nb\0\0\2\0\6\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0K\0\1\0\tjest\27test#javascript#runner\vneovim\18test#strategy\6g\bvim\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-test",
    url = "https://github.com/vim-test/vim-test"
  },
  ["vim-ultest"] = {
    config = { "\27LJ\2\n∑\2\0\0\2\0\15\0!6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0'\1\6\0=\1\5\0006\0\0\0009\0\1\0'\1\b\0=\1\a\0006\0\0\0009\0\1\0'\1\n\0=\1\t\0006\0\0\0009\0\1\0'\1\f\0=\1\v\0006\0\0\0009\0\1\0'\1\f\0=\1\r\0006\0\0\0009\0\1\0'\1\f\0=\1\14\0K\0\1\0\24ultest_running_text\21ultest_fail_text\b‚óè\21ultest_pass_text\6?\24ultest_not_run_sign\b‚óØ\24ultest_running_sign\b‚úñ\21ultest_fail_sign\b‚úî\21ultest_pass_sign\24ultest_virtual_text\6g\bvim\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-ultest",
    url = "https://github.com/rcarriga/vim-ultest"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  },
  ["vim-varnish"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-varnish",
    url = "https://github.com/fgsch/vim-varnish"
  },
  ["vim-vinegar"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-vinegar",
    url = "https://github.com/tpope/vim-vinegar"
  },
  ["vim-visual-multi"] = {
    config = { "\27LJ\2\n0\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\npaper\rvm_theme\6g\bvim\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-visual-multi",
    url = "https://github.com/mg979/vim-visual-multi"
  },
  ["vim-wipeout"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-wipeout",
    url = "https://github.com/artnez/vim-wipeout"
  },
  ["which-key.nvim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  },
  ["zen-mode.nvim"] = {
    config = { "\27LJ\2\n]\0\0\5\0\6\0\b6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3D\1\2\0\fdimming\1\0\0\1\0\1\nalpha\4ö≥ÊÃ\tô≥Ê˛\3\nsetup\rzen-mode\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/zen-mode.nvim",
    url = "https://github.com/folke/zen-mode.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: twilight.nvim
time([[Config for twilight.nvim]], true)
try_loadstring("\27LJ\2\n]\0\0\5\0\6\0\b6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3D\1\2\0\fdimming\1\0\0\1\0\1\nalpha\4ö≥ÊÃ\tô≥Ê˛\3\nsetup\rtwilight\frequire\0", "config", "twilight.nvim")
time([[Config for twilight.nvim]], false)
-- Config for: vim-visual-multi
time([[Config for vim-visual-multi]], true)
try_loadstring("\27LJ\2\n0\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\npaper\rvm_theme\6g\bvim\0", "config", "vim-visual-multi")
time([[Config for vim-visual-multi]], false)
-- Config for: fidget.nvim
time([[Config for fidget.nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\4\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\1\2\0004\3\0\0D\1\2\0\nsetup\vfidget\frequire\0", "config", "fidget.nvim")
time([[Config for fidget.nvim]], false)
-- Config for: emmet-vim
time([[Config for emmet-vim]], true)
try_loadstring("\27LJ\2\n=\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\n<c-y>\26user_emmet_leader_key\6g\bvim\0", "config", "emmet-vim")
time([[Config for emmet-vim]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\nÂ\1\0\0\2\0\b\0\0176\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0K\0\1\0\1\2\0\0\thelp&indent_blankline_filetype_exclude\1\2\0\0\b‚îÉ\31indent_blankline_char_list*indent_blankline_show_current_context$indent_blankline_use_treesitter\6g\bvim\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n{\0\0\6\0\b\0\0146\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\5\0005\4\3\0004\5\0\0=\5\4\4=\4\6\3B\1\2\0019\1\a\0'\3\4\0B\1\2\1K\0\1\0\19load_extension\15extensions\1\0\0\bfzf\1\0\0\nsetup\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n⁄\n\0\0\v\0002\0@6\0\0\0'\2\1\0B\0\2\0029\1\2\0006\2\0\0'\4\3\0B\2\2\2\18\4\2\0009\2\4\2B\2\2\0025\3\6\0005\4\a\0005\5\b\0=\5\t\4=\4\n\3=\3\5\2\18\3\1\0005\5\v\0004\6\0\0=\6\f\0055\6\r\0=\6\14\0055\6\15\0005\a\16\0=\a\17\6=\6\18\0055\6\19\0005\a\20\0=\a\21\6=\6\22\0055\6\23\0004\a\0\0=\a\24\0065\a\25\0=\a\26\6=\6\27\0055\6\28\0005\a\31\0006\b\29\0'\n\30\0B\b\2\2=\b \a=\a\21\6=\6!\0055\6\"\0=\6#\0055\6%\0005\a$\0=\a&\0065\a'\0=\a(\0065\a)\0005\b*\0=\b\21\a=\a+\6=\6,\0055\6-\0004\a\0\0=\a.\6=\6/\0055\0060\0=\0061\5B\3\2\1K\0\1\0\frainbow\1\0\2\venable\2\18extended_mode\2\14highlight\20custom_captures\1\0\1\venable\2\rrefactor\17smart_rename\1\0\1\17smart_rename\15<leader>rr\1\0\1\venable\2\28highlight_current_scope\1\0\1\venable\1\26highlight_definitions\1\0\0\1\0\1\venable\2\vindent\1\0\1\venable\2\26incremental_selection\19init_selection\1\0\3\22scope_incremental\n<M-N>\21node_decremental\n<M-p>\21node_incremental\n<M-n>\14<leader>v\6t\1\0\1\venable\2\15playground\16keybindings\1\0\n\27toggle_anonymous_nodes\6a\30toggle_injected_languages\6t\21toggle_hl_groups\6i\24toggle_query_editor\6o\14show_help\6?\14goto_node\t<cr>\vupdate\6R\21unfocus_language\6F\19focus_language\6f\28toggle_language_display\6I\fdisable\1\0\3\venable\2\15updatetime\3\25\20persist_queries\1\17textsubjects\fkeymaps\1\0\3\6.\23textsubjects-smart\ai;!textsubjects-container-inner\6;!textsubjects-container-outer\1\0\2\venable\2\19prev_selection\6,\17query_linter\16lint_events\1\3\0\0\rBufWrite\15CursorHold\1\0\2\venable\2\21use_virtual_text\2\16treeclimber\1\0\1\venable\2\21ensure_installed\1\0\0\17install_info\nfiles\1\3\0\0\17src/parser.c\19src/scanner.cc\1\0\2\burl3https://github.com/MDeiml/tree-sitter-markdown\rrevision\tmain\1\0\1\rfiletype\rmarkdown\rmarkdown\23get_parser_configs\28nvim-treesitter.parsers\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: symbols-outline.nvim
time([[Config for symbols-outline.nvim]], true)
try_loadstring("\27LJ\2\nø\2\0\0\3\0\a\0\t6\0\0\0009\0\1\0005\1\3\0005\2\4\0=\2\5\0014\2\0\0=\2\6\1=\1\2\0K\0\1\0\18lsp_blacklist\fkeymaps\1\0\6\17code_actions\6a\nclose\n<Esc>\18rename_symbol\6r\17hover_symbol\14<C-space>\19focus_location\6o\18goto_location\t<Cr>\1\0\a\24show_symbol_details\2\26show_relative_numbers\1\17show_numbers\1\rposition\nright\17auto_preview\2\16show_guides\2\27highlight_hovered_item\2\20symbols_outline\6g\bvim\0", "config", "symbols-outline.nvim")
time([[Config for symbols-outline.nvim]], false)
-- Config for: refactoring.nvim
time([[Config for refactoring.nvim]], true)
try_loadstring("\27LJ\2\nn\0\0\3\0\5\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0016\0\0\0'\2\3\0B\0\2\0029\0\4\0'\2\1\0B\0\2\1K\0\1\0\19load_extension\14telescope\nsetup\16refactoring\frequire\0", "config", "refactoring.nvim")
time([[Config for refactoring.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n≤\4\0\0\6\0\18\0\0206\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0035\4\a\0005\5\6\0=\5\b\0045\5\t\0=\5\n\0045\5\v\0=\5\f\0045\5\r\0=\5\14\0045\5\15\0=\5\16\4=\4\17\3D\1\2\0\nsigns\17changedelete\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\6~\vlinehl\21GitSignsChangeLn\14topdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\b‚Äæ\vlinehl\21GitSignsDeleteLn\vdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\6_\vlinehl\21GitSignsDeleteLn\vchange\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\b‚îÇ\vlinehl\21GitSignsChangeLn\badd\1\0\0\1\0\4\ahl\16GitSignsAdd\nnumhl\18GitSignsAddNr\ttext\b‚îÇ\vlinehl\18GitSignsAddLn\16watch_index\1\0\0\1\0\1\rinterval\3Ë\a\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: zen-mode.nvim
time([[Config for zen-mode.nvim]], true)
try_loadstring("\27LJ\2\n]\0\0\5\0\6\0\b6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3D\1\2\0\fdimming\1\0\0\1\0\1\nalpha\4ö≥ÊÃ\tô≥Ê˛\3\nsetup\rzen-mode\frequire\0", "config", "zen-mode.nvim")
time([[Config for zen-mode.nvim]], false)
-- Config for: vim-test
time([[Config for vim-test]], true)
try_loadstring("\27LJ\2\nb\0\0\2\0\6\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0K\0\1\0\tjest\27test#javascript#runner\vneovim\18test#strategy\6g\bvim\0", "config", "vim-test")
time([[Config for vim-test]], false)
-- Config for: vim-ultest
time([[Config for vim-ultest]], true)
try_loadstring("\27LJ\2\n∑\2\0\0\2\0\15\0!6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0'\1\6\0=\1\5\0006\0\0\0009\0\1\0'\1\b\0=\1\a\0006\0\0\0009\0\1\0'\1\n\0=\1\t\0006\0\0\0009\0\1\0'\1\f\0=\1\v\0006\0\0\0009\0\1\0'\1\f\0=\1\r\0006\0\0\0009\0\1\0'\1\f\0=\1\14\0K\0\1\0\24ultest_running_text\21ultest_fail_text\b‚óè\21ultest_pass_text\6?\24ultest_not_run_sign\b‚óØ\24ultest_running_sign\b‚úñ\21ultest_fail_sign\b‚úî\21ultest_pass_sign\24ultest_virtual_text\6g\bvim\0", "config", "vim-ultest")
time([[Config for vim-ultest]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType fennel ++once lua require("packer.load")({'fennel.vim'}, { ft = "fennel" }, _G.packer_plugins)]]
vim.cmd [[au FileType fish ++once lua require("packer.load")({'vim-fish'}, { ft = "fish" }, _G.packer_plugins)]]
vim.cmd [[au FileType elixir ++once lua require("packer.load")({'vim-elixir'}, { ft = "elixir" }, _G.packer_plugins)]]
vim.cmd [[au FileType jsonnet ++once lua require("packer.load")({'vim-jsonnet'}, { ft = "jsonnet" }, _G.packer_plugins)]]
vim.cmd [[au FileType eelixer ++once lua require("packer.load")({'vim-elixir'}, { ft = "eelixer" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/fennel.vim/ftdetect/fennel.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/fennel.vim/ftdetect/fennel.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/fennel.vim/ftdetect/fennel.vim]], false)
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-jsonnet/ftdetect/jsonnet.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-jsonnet/ftdetect/jsonnet.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-jsonnet/ftdetect/jsonnet.vim]], false)
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-elixir/ftdetect/elixir.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-elixir/ftdetect/elixir.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-elixir/ftdetect/elixir.vim]], false)
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
