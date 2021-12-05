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
  local success, result = pcall(loadstring(s))
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
  ["cmp-tabnine"] = {
    config = { "\27LJ\2\nÑ\1\0\0\5\0\4\0\a6\0\0\0'\2\1\0B\0\2\2\18\3\0\0009\1\2\0005\4\3\0D\1\3\0\1\0\4\27run_on_every_keystroke\2\tsort\2\14max_lines\3Ë\a\20max_num_results\3\20\nsetup\23cmp_tabnine.config\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/cmp-tabnine",
    url = "https://github.com/tzachar/cmp-tabnine"
  },
  ["cmp-vsnip"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/cmp-vsnip",
    url = "https://github.com/hrsh7th/cmp-vsnip"
  },
  ["earthly.vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/earthly.vim",
    url = "https://github.com/earthly/earthly.vim"
  },
  ["emmet-vim"] = {
    config = { "\27LJ\2\nA\0\0\2\0\4\0\0066\0\0\0009\0\1\0'\1\3\0=\1\2\0+\0\0\0L\0\2\0\n<c-y>\26user_emmet_leader_key\6g\bvim\0" },
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
  ["file-line"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/file-line",
    url = "https://github.com/bogado/file-line"
  },
  ["filetype.nvim"] = {
    config = { "\27LJ\2\n”\1\0\0\6\0\f\0\0216\0\0\0'\2\1\0B\0\2\2\18\2\0\0009\0\2\0005\3\n\0005\4\3\0004\5\0\0=\5\4\0044\5\0\0=\5\5\0044\5\0\0=\5\6\0044\5\0\0=\5\a\0044\5\0\0=\5\b\0044\5\0\0=\5\t\4=\4\v\3D\0\3\0\14overrides\1\0\0\fliteral\21function_literal\24function_extensions\21function_complex\15extensions\fcomplex\1\0\0\nsetup\rfiletype\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/filetype.nvim",
    url = "https://github.com/nathom/filetype.nvim"
  },
  ["formatter.nvim"] = {
    config = { "\27LJ\2\n*\0\0\3\0\2\0\0036\0\0\0'\2\1\0D\0\2\0\19user.formatter\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/formatter.nvim",
    url = "https://github.com/mhartington/formatter.nvim"
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
  ["galaxyline.nvim"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\2D\0\1\0\20user.statusline\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/galaxyline.nvim",
    url = "https://github.com/glepnir/galaxyline.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n$\0\0\2\0\2\0\0036\0\0\0009\0\1\0D\0\1\0\rgitsigns\fplugins\0" },
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
    config = { "\27LJ\2\n,\0\0\2\0\2\0\0036\0\0\0009\0\1\0D\0\1\0\21indent-blankline\fplugins\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["jsonc.vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/jsonc.vim",
    url = "https://github.com/neoclide/jsonc.vim"
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
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n\31\0\0\2\0\2\0\0036\0\0\0009\0\1\0D\0\1\0\bcmp\fplugins\0" },
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
    config = { "\27LJ\2\n*\0\0\3\0\2\0\0036\0\0\0'\2\1\0D\0\2\0\19init-lspconfig\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0036\0\0\0'\2\1\0D\0\2\0\20user.treesitter\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/romgrk/nvim-treesitter-context"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
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
  ["orgmode.nvim"] = {
    config = { "\27LJ\2\nç\1\0\0\5\0\6\0\t6\0\0\0'\2\1\0B\0\2\2\18\2\0\0009\0\2\0005\3\4\0005\4\3\0=\4\5\3D\0\3\0\21org_agenda_files\1\0\1\27org_default_notes_file\20~/notes/gtd.org\1\2\0\0\17~/notes/**/*\nsetup\forgmode\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/orgmode.nvim",
    url = "https://github.com/kristijanhusak/orgmode.nvim"
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
  ["startuptime.vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/startuptime.vim",
    url = "https://github.com/tweekmonster/startuptime.vim"
  },
  ["symbols-outline.nvim"] = {
    config = { "\27LJ\2\n+\0\0\2\0\2\0\0036\0\0\0009\0\1\0D\0\1\0\20symbols-outline\fplugins\0" },
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
    config = { "\27LJ\2\nw\0\0\6\0\b\0\r6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\5\0005\4\3\0004\5\0\0=\5\4\4=\4\6\3B\1\2\0019\1\a\0'\3\4\0D\1\2\0\19load_extension\15extensions\1\0\0\bfzf\1\0\0\nsetup\14telescope\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n#\0\0\2\0\2\0\0036\0\0\0009\0\1\0D\0\1\0\ftrouble\fplugins\0" },
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
  ["typescript-vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/typescript-vim",
    url = "https://github.com/leafgarland/typescript-vim"
  },
  ["vCoolor.vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vCoolor.vim",
    url = "https://github.com/KabbAmine/vCoolor.vim"
  },
  ["vader.vim"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vader.vim",
    url = "https://github.com/junegunn/vader.vim"
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
    config = { "\27LJ\2\n&\0\0\2\0\2\0\0036\0\0\0009\0\1\0D\0\1\0\15vim-elixir\fplugins\0" },
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
  ["vim-ghost"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-ghost",
    url = "https://github.com/raghur/vim-ghost"
  },
  ["vim-gnupg"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-gnupg",
    url = "https://github.com/jamessan/vim-gnupg"
  },
  ["vim-graphql"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-graphql",
    url = "https://github.com/jparise/vim-graphql"
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
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-test",
    url = "https://github.com/janko-m/vim-test"
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
    config = { "\27LJ\2\n4\0\0\2\0\4\0\0066\0\0\0009\0\1\0'\1\3\0=\1\2\0+\0\0\0L\0\2\0\npaper\rVM_theme\6g\bvim\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-visual-multi",
    url = "https://github.com/mg979/vim-visual-multi"
  },
  ["vim-vsnip"] = {
    config = { "\27LJ\2\nx\0\0\3\0\t\0\v5\0\1\0005\1\0\0=\1\2\0005\1\4\0005\2\3\0=\2\5\0016\2\6\0009\2\a\2=\1\b\2+\2\0\0L\2\2\0\20vsnip_filetypes\6g\bvim\15typescript\1\0\0\1\2\0\0\15javascript\njsonc\1\0\0\1\2\0\0\tjson\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ",
    url = "https://github.com/hrsh7th/vim-vsnip-integ"
  },
  ["vim-wipeout"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-wipeout",
    url = "https://github.com/artnez/vim-wipeout"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n7\0\0\4\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\1\2\0004\3\0\0D\1\2\0\nsetup\14which-key\frequire\0" },
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
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\nw\0\0\6\0\b\0\r6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\5\0005\4\3\0004\5\0\0=\5\4\4=\4\6\3B\1\2\0019\1\a\0'\3\4\0D\1\2\0\19load_extension\15extensions\1\0\0\bfzf\1\0\0\nsetup\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\4\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\1\2\0004\3\0\0D\1\2\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n#\0\0\2\0\2\0\0036\0\0\0009\0\1\0D\0\1\0\ftrouble\fplugins\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: zen-mode.nvim
time([[Config for zen-mode.nvim]], true)
try_loadstring("\27LJ\2\n]\0\0\5\0\6\0\b6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3D\1\2\0\fdimming\1\0\0\1\0\1\nalpha\4ö≥ÊÃ\tô≥Ê˛\3\nsetup\rzen-mode\frequire\0", "config", "zen-mode.nvim")
time([[Config for zen-mode.nvim]], false)
-- Config for: orgmode.nvim
time([[Config for orgmode.nvim]], true)
try_loadstring("\27LJ\2\nç\1\0\0\5\0\6\0\t6\0\0\0'\2\1\0B\0\2\2\18\2\0\0009\0\2\0005\3\4\0005\4\3\0=\4\5\3D\0\3\0\21org_agenda_files\1\0\1\27org_default_notes_file\20~/notes/gtd.org\1\2\0\0\17~/notes/**/*\nsetup\forgmode\frequire\0", "config", "orgmode.nvim")
time([[Config for orgmode.nvim]], false)
-- Config for: filetype.nvim
time([[Config for filetype.nvim]], true)
try_loadstring("\27LJ\2\n”\1\0\0\6\0\f\0\0216\0\0\0'\2\1\0B\0\2\2\18\2\0\0009\0\2\0005\3\n\0005\4\3\0004\5\0\0=\5\4\0044\5\0\0=\5\5\0044\5\0\0=\5\6\0044\5\0\0=\5\a\0044\5\0\0=\5\b\0044\5\0\0=\5\t\4=\4\v\3D\0\3\0\14overrides\1\0\0\fliteral\21function_literal\24function_extensions\21function_complex\15extensions\fcomplex\1\0\0\nsetup\rfiletype\frequire\0", "config", "filetype.nvim")
time([[Config for filetype.nvim]], false)
-- Config for: formatter.nvim
time([[Config for formatter.nvim]], true)
try_loadstring("\27LJ\2\n*\0\0\3\0\2\0\0036\0\0\0'\2\1\0D\0\2\0\19user.formatter\frequire\0", "config", "formatter.nvim")
time([[Config for formatter.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n\31\0\0\2\0\2\0\0036\0\0\0009\0\1\0D\0\1\0\bcmp\fplugins\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0036\0\0\0'\2\1\0D\0\2\0\20user.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: vim-visual-multi
time([[Config for vim-visual-multi]], true)
try_loadstring("\27LJ\2\n4\0\0\2\0\4\0\0066\0\0\0009\0\1\0'\1\3\0=\1\2\0+\0\0\0L\0\2\0\npaper\rVM_theme\6g\bvim\0", "config", "vim-visual-multi")
time([[Config for vim-visual-multi]], false)
-- Config for: symbols-outline.nvim
time([[Config for symbols-outline.nvim]], true)
try_loadstring("\27LJ\2\n+\0\0\2\0\2\0\0036\0\0\0009\0\1\0D\0\1\0\20symbols-outline\fplugins\0", "config", "symbols-outline.nvim")
time([[Config for symbols-outline.nvim]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\2D\0\1\0\20user.statusline\frequire\0", "config", "galaxyline.nvim")
time([[Config for galaxyline.nvim]], false)
-- Config for: vim-vsnip
time([[Config for vim-vsnip]], true)
try_loadstring("\27LJ\2\nx\0\0\3\0\t\0\v5\0\1\0005\1\0\0=\1\2\0005\1\4\0005\2\3\0=\2\5\0016\2\6\0009\2\a\2=\1\b\2+\2\0\0L\2\2\0\20vsnip_filetypes\6g\bvim\15typescript\1\0\0\1\2\0\0\15javascript\njsonc\1\0\0\1\2\0\0\tjson\0", "config", "vim-vsnip")
time([[Config for vim-vsnip]], false)
-- Config for: cmp-tabnine
time([[Config for cmp-tabnine]], true)
try_loadstring("\27LJ\2\nÑ\1\0\0\5\0\4\0\a6\0\0\0'\2\1\0B\0\2\2\18\3\0\0009\1\2\0005\4\3\0D\1\3\0\1\0\4\27run_on_every_keystroke\2\tsort\2\14max_lines\3Ë\a\20max_num_results\3\20\nsetup\23cmp_tabnine.config\frequire\0", "config", "cmp-tabnine")
time([[Config for cmp-tabnine]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\n,\0\0\2\0\2\0\0036\0\0\0009\0\1\0D\0\1\0\21indent-blankline\fplugins\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n$\0\0\2\0\2\0\0036\0\0\0009\0\1\0D\0\1\0\rgitsigns\fplugins\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: twilight.nvim
time([[Config for twilight.nvim]], true)
try_loadstring("\27LJ\2\n]\0\0\5\0\6\0\b6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3D\1\2\0\fdimming\1\0\0\1\0\1\nalpha\4ö≥ÊÃ\tô≥Ê˛\3\nsetup\rtwilight\frequire\0", "config", "twilight.nvim")
time([[Config for twilight.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n*\0\0\3\0\2\0\0036\0\0\0'\2\1\0D\0\2\0\19init-lspconfig\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: emmet-vim
time([[Config for emmet-vim]], true)
try_loadstring("\27LJ\2\nA\0\0\2\0\4\0\0066\0\0\0009\0\1\0'\1\3\0=\1\2\0+\0\0\0L\0\2\0\n<c-y>\26user_emmet_leader_key\6g\bvim\0", "config", "emmet-vim")
time([[Config for emmet-vim]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType fennel ++once lua require("packer.load")({'fennel.vim'}, { ft = "fennel" }, _G.packer_plugins)]]
vim.cmd [[au FileType elixir ++once lua require("packer.load")({'vim-elixir'}, { ft = "elixir" }, _G.packer_plugins)]]
vim.cmd [[au FileType eelixer ++once lua require("packer.load")({'vim-elixir'}, { ft = "eelixer" }, _G.packer_plugins)]]
vim.cmd [[au FileType fish ++once lua require("packer.load")({'vim-fish'}, { ft = "fish" }, _G.packer_plugins)]]
vim.cmd [[au FileType jsonnet ++once lua require("packer.load")({'vim-jsonnet'}, { ft = "jsonnet" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/fennel.vim/ftdetect/fennel.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/fennel.vim/ftdetect/fennel.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/fennel.vim/ftdetect/fennel.vim]], false)
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]], false)
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-elixir/ftdetect/elixir.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-elixir/ftdetect/elixir.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-elixir/ftdetect/elixir.vim]], false)
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-jsonnet/ftdetect/jsonnet.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-jsonnet/ftdetect/jsonnet.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-jsonnet/ftdetect/jsonnet.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
