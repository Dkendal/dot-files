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
  ["formatter.nvim"] = {
    config = { "\27LJ\2\nÒ\1\0\0\6\0\r\0!6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0B\0\3\2\n\0\0\0X\1\2Ä\a\0\5\0X\1\1ÄK\0\1\0006\1\0\0009\1\1\0019\1\6\0016\3\0\0009\3\1\0039\3\a\3\18\5\0\0B\3\2\0A\1\0\0029\2\b\1\14\0\2\0X\2\1ÄK\0\1\0009\2\b\0019\2\t\2\14\0\2\0X\2\1ÄK\0\1\0005\2\n\0005\3\v\0=\3\f\2L\2\2\0\targs\1\3\0\0\brun\bfmt\1\0\2\nstdin\1\bexe\tyarn\bfmt\fscripts\rreadfile\16json_decode\5\a.;\17package.json\rfindfile\afn\bvimB\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\3\0\0\a-i\17's/[ \t]*$//'\1\0\2\nstdin\2\bexe\bsed0\0\0\2\0\2\0\0045\0\0\0004\1\0\0=\1\1\0L\0\2\0\targs\1\0\2\nstdin\2\bexe\nshfmt;\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\3\0\0\vformat\6-\1\0\2\nstdin\2\bexe\bmix7\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\2\0\0\6-\1\0\2\nstdin\2\bexe\vfnlfmt[\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\5\0\0\18--indent-type\vSpaces\19--indent-width\0062\1\0\2\nstdin\1\bexe\vstylua?\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\2\0\0\f--write\1\0\2\nstdin\1\bexe\rprettierA\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\4\0\0\bfmt\f--width\3P\1\0\2\nstdin\2\bexe\tracof\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\a\0\0\16js-beautify\23--end-with-newline\v--type\thtml\v--file\6-\1\0\2\nstdin\2\bexe\bnpx5\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\2\0\0\b'.'\1\0\2\nstdin\2\bexe\ajq/\0\0\2\0\2\0\0045\0\0\0004\1\0\0=\1\1\0L\0\2\0\targs\1\0\2\nstdin\1\bexe\trufo5\0\0\2\0\2\0\0045\0\0\0004\1\0\0=\1\1\0L\0\2\0\targs\1\0\2\nstdin\1\bexe\15buildifier4\0\0\2\0\2\0\0045\0\0\0004\1\0\0=\1\1\0L\0\2\0\targs\1\0\2\nstdin\2\bexe\14pg_format'\0\0\2\2\0\0\a-\0\0\0B\0\1\2\14\0\0\0X\1\2Ä-\0\1\0B\0\1\2L\0\2\0\1¿\a¿'\0\0\2\2\0\0\a-\0\0\0B\0\1\2\14\0\0\0X\1\2Ä-\0\1\0B\0\1\2L\0\2\0\1¿\a¿'\0\0\2\2\0\0\a-\0\0\0B\0\1\2\14\0\0\0X\1\2Ä-\0\1\0B\0\1\2L\0\2\0\1¿\a¿'\0\0\2\2\0\0\a-\0\0\0B\0\1\2\14\0\0\0X\1\2Ä-\0\1\0B\0\1\2L\0\2\0\1¿\a¿'\0\0\2\2\0\0\a-\0\0\0B\0\1\2\14\0\0\0X\1\2Ä-\0\1\0B\0\1\2L\0\2\0\1¿\a¿µ\4\1\0\20\0,\0X6\0\0\0'\2\1\0B\0\2\0023\1\2\0003\2\3\0003\3\4\0003\4\5\0003\5\6\0003\6\a\0003\a\b\0003\b\t\0003\t\n\0003\n\v\0003\v\f\0003\f\r\0003\r\14\0009\14\15\0005\16\16\0005\17\17\0004\18\3\0>\2\1\18=\18\18\0174\18\3\0>\r\1\18=\18\19\0174\18\3\0>\3\1\18=\18\20\0174\18\3\0>\3\1\18=\18\21\0174\18\3\0>\v\1\18=\18\22\0174\18\3\0>\4\1\18=\18\23\0174\18\3\0>\t\1\18=\18\24\0174\18\3\0>\f\1\18=\18\25\0174\18\3\0>\5\1\18=\18\26\0174\18\3\0>\6\1\18=\18\27\0174\18\3\0>\b\1\18=\18\28\0174\18\3\0>\n\1\18=\18\29\0174\18\3\0>\n\1\18=\18\30\0174\18\3\0003\19\31\0>\19\1\18=\18 \0174\18\3\0>\a\1\18=\18!\0174\18\3\0003\19\"\0>\19\1\18=\18#\0174\18\3\0>\a\1\18=\18$\0174\18\3\0003\19%\0>\19\1\18=\18&\0174\18\3\0003\19'\0>\19\1\18=\18(\0174\18\3\0003\19)\0>\19\1\18=\18*\17=\17+\16B\14\2\0012\0\0ÄK\0\1\0\rfiletype\20typescriptreact\0\20javascriptreact\0\15typescript\0\thtml\rmarkdown\0\tyaml\15javascript\0\njsonc\tjson\vracket\blua\vfennel\bbzl\feelixir\velixir\truby\tbash\ash\bsql\6*\1\0\0\1\0\1\flogging\2\nsetup\0\0\0\0\0\0\0\0\0\0\0\0\0\14formatter\frequire\0" },
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
    config = { "\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\2D\0\1\0\24fnl.user.statusline\frequire\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/galaxyline.nvim",
    url = "https://github.com/glepnir/galaxyline.nvim"
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
    config = { "\27LJ\2\nÅ\f\0\0\v\0008\0H6\0\0\0'\2\1\0B\0\2\0029\1\2\0006\2\0\0'\4\3\0B\2\2\2\18\4\2\0009\2\4\2B\2\2\0025\3\6\0005\4\a\0=\4\b\3=\3\5\0025\3\n\0005\4\v\0005\5\f\0=\5\r\4=\4\b\3=\3\t\2\18\3\1\0005\5\14\0004\6\0\0=\6\15\0055\6\16\0=\6\17\0055\6\18\0005\a\19\0=\a\20\6=\6\21\0055\6\22\0005\a\23\0=\a\24\6=\6\25\0055\6\26\0004\a\0\0=\a\27\0065\a\28\0=\a\29\6=\6\30\0055\6\31\0005\a\"\0006\b \0'\n!\0B\b\2\2=\b#\a=\a\24\6=\6$\0055\6%\0=\6&\0055\6(\0005\a'\0=\a)\0065\a*\0=\a+\0065\a,\0005\b-\0=\b\24\a=\a.\6=\6/\0055\0060\0005\a1\0=\a\27\0065\a2\0=\a3\0064\a\0\0=\a4\6=\0065\0055\0066\0=\0067\5B\3\2\1K\0\1\0\frainbow\1\0\2\venable\2\18extended_mode\2\14highlight\20custom_captures&additional_vim_regex_highlighting\1\2\0\0\borg\1\2\0\0\borg\1\0\1\venable\2\rrefactor\17smart_rename\1\0\1\17smart_rename\15<leader>rr\1\0\1\venable\2\28highlight_current_scope\1\0\1\venable\1\26highlight_definitions\1\0\0\1\0\1\venable\2\vindent\1\0\1\venable\2\26incremental_selection\19init_selection\1\0\3\22scope_incremental\n<M-N>\21node_decremental\n<M-p>\21node_incremental\n<M-n>\14<leader>v\6t\1\0\1\venable\2\15playground\16keybindings\1\0\n\14goto_node\t<cr>\vupdate\6R\21unfocus_language\6F\19focus_language\6f\28toggle_language_display\6I\27toggle_anonymous_nodes\6a\30toggle_injected_languages\6t\21toggle_hl_groups\6i\24toggle_query_editor\6o\14show_help\6?\fdisable\1\0\3\15updatetime\3\25\venable\2\20persist_queries\1\17textsubjects\fkeymaps\1\0\3\6;!textsubjects-container-outer\ai;!textsubjects-container-inner\6.\23textsubjects-smart\1\0\2\19prev_selection\6,\venable\2\17query_linter\16lint_events\1\3\0\0\rBufWrite\15CursorHold\1\0\2\21use_virtual_text\2\venable\2\16treeclimber\1\0\1\venable\2\21ensure_installed\1\0\0\nfiles\1\3\0\0\17src/parser.c\19src/scanner.cc\1\0\2\rrevision\tmain\burl3https://github.com/MDeiml/tree-sitter-markdown\1\0\1\rfiletype\rmarkdown\rmarkdown\17install_info\1\0\2\rrevision\tmain\burl0https://github.com/milisims/tree-sitter-org\1\0\1\rfiletype\borg\borg\23get_parser_configs\28nvim-treesitter.parsers\nsetup\28nvim-treesitter.configs\frequire\0" },
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
  ["orgmode.nvim"] = {
    config = { "\27LJ\2\në\1\0\0\5\0\6\0\n6\0\0\0'\2\1\0B\0\2\2\18\2\0\0009\0\2\0005\3\4\0005\4\3\0=\4\5\3B\0\3\1K\0\1\0\21org_agenda_files\1\0\1\27org_default_notes_file\20~/notes/gtd.org\1\2\0\0\17~/notes/**/*\nsetup\forgmode\frequire\0" },
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
  ["rainbow_parentheses.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/opt/rainbow_parentheses.vim",
    url = "https://github.com/junegunn/rainbow_parentheses.vim"
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
    config = { "\27LJ\2\nø\2\0\0\3\0\a\0\t6\0\0\0009\0\1\0005\1\3\0005\2\4\0=\2\5\0014\2\0\0=\2\6\1=\1\2\0K\0\1\0\18lsp_blacklist\fkeymaps\1\0\6\17hover_symbol\14<C-space>\19focus_location\6o\nclose\n<Esc>\18goto_location\t<Cr>\17code_actions\6a\18rename_symbol\6r\1\0\a\24show_symbol_details\2\26show_relative_numbers\1\17show_numbers\1\rposition\nright\17auto_preview\2\16show_guides\2\27highlight_hovered_item\2\20symbols_outline\6g\bvim\0" },
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
  ["vim-closer"] = {
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-closer",
    url = "https://github.com/rstacruz/vim-closer"
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
    config = { "\27LJ\2\nb\0\0\2\0\6\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0K\0\1\0\tjest\27test#javascript#runner\vneovim\18test#strategy\6g\bvim\0" },
    loaded = true,
    path = "/home/dylan/.local/share/nvim/site/pack/packer/start/vim-test",
    url = "https://github.com/vim-test/vim-test"
  },
  ["vim-ultest"] = {
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
-- Config for: formatter.nvim
time([[Config for formatter.nvim]], true)
try_loadstring("\27LJ\2\nÒ\1\0\0\6\0\r\0!6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0B\0\3\2\n\0\0\0X\1\2Ä\a\0\5\0X\1\1ÄK\0\1\0006\1\0\0009\1\1\0019\1\6\0016\3\0\0009\3\1\0039\3\a\3\18\5\0\0B\3\2\0A\1\0\0029\2\b\1\14\0\2\0X\2\1ÄK\0\1\0009\2\b\0019\2\t\2\14\0\2\0X\2\1ÄK\0\1\0005\2\n\0005\3\v\0=\3\f\2L\2\2\0\targs\1\3\0\0\brun\bfmt\1\0\2\nstdin\1\bexe\tyarn\bfmt\fscripts\rreadfile\16json_decode\5\a.;\17package.json\rfindfile\afn\bvimB\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\3\0\0\a-i\17's/[ \t]*$//'\1\0\2\nstdin\2\bexe\bsed0\0\0\2\0\2\0\0045\0\0\0004\1\0\0=\1\1\0L\0\2\0\targs\1\0\2\nstdin\2\bexe\nshfmt;\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\3\0\0\vformat\6-\1\0\2\nstdin\2\bexe\bmix7\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\2\0\0\6-\1\0\2\nstdin\2\bexe\vfnlfmt[\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\5\0\0\18--indent-type\vSpaces\19--indent-width\0062\1\0\2\nstdin\1\bexe\vstylua?\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\2\0\0\f--write\1\0\2\nstdin\1\bexe\rprettierA\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\4\0\0\bfmt\f--width\3P\1\0\2\nstdin\2\bexe\tracof\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\a\0\0\16js-beautify\23--end-with-newline\v--type\thtml\v--file\6-\1\0\2\nstdin\2\bexe\bnpx5\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\2\0\0\b'.'\1\0\2\nstdin\2\bexe\ajq/\0\0\2\0\2\0\0045\0\0\0004\1\0\0=\1\1\0L\0\2\0\targs\1\0\2\nstdin\1\bexe\trufo5\0\0\2\0\2\0\0045\0\0\0004\1\0\0=\1\1\0L\0\2\0\targs\1\0\2\nstdin\1\bexe\15buildifier4\0\0\2\0\2\0\0045\0\0\0004\1\0\0=\1\1\0L\0\2\0\targs\1\0\2\nstdin\2\bexe\14pg_format'\0\0\2\2\0\0\a-\0\0\0B\0\1\2\14\0\0\0X\1\2Ä-\0\1\0B\0\1\2L\0\2\0\1¿\a¿'\0\0\2\2\0\0\a-\0\0\0B\0\1\2\14\0\0\0X\1\2Ä-\0\1\0B\0\1\2L\0\2\0\1¿\a¿'\0\0\2\2\0\0\a-\0\0\0B\0\1\2\14\0\0\0X\1\2Ä-\0\1\0B\0\1\2L\0\2\0\1¿\a¿'\0\0\2\2\0\0\a-\0\0\0B\0\1\2\14\0\0\0X\1\2Ä-\0\1\0B\0\1\2L\0\2\0\1¿\a¿'\0\0\2\2\0\0\a-\0\0\0B\0\1\2\14\0\0\0X\1\2Ä-\0\1\0B\0\1\2L\0\2\0\1¿\a¿µ\4\1\0\20\0,\0X6\0\0\0'\2\1\0B\0\2\0023\1\2\0003\2\3\0003\3\4\0003\4\5\0003\5\6\0003\6\a\0003\a\b\0003\b\t\0003\t\n\0003\n\v\0003\v\f\0003\f\r\0003\r\14\0009\14\15\0005\16\16\0005\17\17\0004\18\3\0>\2\1\18=\18\18\0174\18\3\0>\r\1\18=\18\19\0174\18\3\0>\3\1\18=\18\20\0174\18\3\0>\3\1\18=\18\21\0174\18\3\0>\v\1\18=\18\22\0174\18\3\0>\4\1\18=\18\23\0174\18\3\0>\t\1\18=\18\24\0174\18\3\0>\f\1\18=\18\25\0174\18\3\0>\5\1\18=\18\26\0174\18\3\0>\6\1\18=\18\27\0174\18\3\0>\b\1\18=\18\28\0174\18\3\0>\n\1\18=\18\29\0174\18\3\0>\n\1\18=\18\30\0174\18\3\0003\19\31\0>\19\1\18=\18 \0174\18\3\0>\a\1\18=\18!\0174\18\3\0003\19\"\0>\19\1\18=\18#\0174\18\3\0>\a\1\18=\18$\0174\18\3\0003\19%\0>\19\1\18=\18&\0174\18\3\0003\19'\0>\19\1\18=\18(\0174\18\3\0003\19)\0>\19\1\18=\18*\17=\17+\16B\14\2\0012\0\0ÄK\0\1\0\rfiletype\20typescriptreact\0\20javascriptreact\0\15typescript\0\thtml\rmarkdown\0\tyaml\15javascript\0\njsonc\tjson\vracket\blua\vfennel\bbzl\feelixir\velixir\truby\tbash\ash\bsql\6*\1\0\0\1\0\1\flogging\2\nsetup\0\0\0\0\0\0\0\0\0\0\0\0\0\14formatter\frequire\0", "config", "formatter.nvim")
time([[Config for formatter.nvim]], false)
-- Config for: vim-test
time([[Config for vim-test]], true)
try_loadstring("\27LJ\2\nb\0\0\2\0\6\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0K\0\1\0\tjest\27test#javascript#runner\vneovim\18test#strategy\6g\bvim\0", "config", "vim-test")
time([[Config for vim-test]], false)
-- Config for: fidget.nvim
time([[Config for fidget.nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\4\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\1\2\0004\3\0\0D\1\2\0\nsetup\vfidget\frequire\0", "config", "fidget.nvim")
time([[Config for fidget.nvim]], false)
-- Config for: symbols-outline.nvim
time([[Config for symbols-outline.nvim]], true)
try_loadstring("\27LJ\2\nø\2\0\0\3\0\a\0\t6\0\0\0009\0\1\0005\1\3\0005\2\4\0=\2\5\0014\2\0\0=\2\6\1=\1\2\0K\0\1\0\18lsp_blacklist\fkeymaps\1\0\6\17hover_symbol\14<C-space>\19focus_location\6o\nclose\n<Esc>\18goto_location\t<Cr>\17code_actions\6a\18rename_symbol\6r\1\0\a\24show_symbol_details\2\26show_relative_numbers\1\17show_numbers\1\rposition\nright\17auto_preview\2\16show_guides\2\27highlight_hovered_item\2\20symbols_outline\6g\bvim\0", "config", "symbols-outline.nvim")
time([[Config for symbols-outline.nvim]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
try_loadstring("\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\2D\0\1\0\24fnl.user.statusline\frequire\0", "config", "galaxyline.nvim")
time([[Config for galaxyline.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n{\0\0\6\0\b\0\0146\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\5\0005\4\3\0004\5\0\0=\5\4\4=\4\6\3B\1\2\0019\1\a\0'\3\4\0B\1\2\1K\0\1\0\19load_extension\15extensions\1\0\0\bfzf\1\0\0\nsetup\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n≤\4\0\0\6\0\18\0\0206\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0035\4\a\0005\5\6\0=\5\b\0045\5\t\0=\5\n\0045\5\v\0=\5\f\0045\5\r\0=\5\14\0045\5\15\0=\5\16\4=\4\17\3D\1\2\0\nsigns\17changedelete\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\6~\vlinehl\21GitSignsChangeLn\14topdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\b‚Äæ\vlinehl\21GitSignsDeleteLn\vdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\6_\vlinehl\21GitSignsDeleteLn\vchange\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\b‚îÇ\vlinehl\21GitSignsChangeLn\badd\1\0\0\1\0\4\ahl\16GitSignsAdd\nnumhl\18GitSignsAddNr\ttext\b‚îÇ\vlinehl\18GitSignsAddLn\16watch_index\1\0\0\1\0\1\rinterval\3Ë\a\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: vim-visual-multi
time([[Config for vim-visual-multi]], true)
try_loadstring("\27LJ\2\n0\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\npaper\rvm_theme\6g\bvim\0", "config", "vim-visual-multi")
time([[Config for vim-visual-multi]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nÅ\f\0\0\v\0008\0H6\0\0\0'\2\1\0B\0\2\0029\1\2\0006\2\0\0'\4\3\0B\2\2\2\18\4\2\0009\2\4\2B\2\2\0025\3\6\0005\4\a\0=\4\b\3=\3\5\0025\3\n\0005\4\v\0005\5\f\0=\5\r\4=\4\b\3=\3\t\2\18\3\1\0005\5\14\0004\6\0\0=\6\15\0055\6\16\0=\6\17\0055\6\18\0005\a\19\0=\a\20\6=\6\21\0055\6\22\0005\a\23\0=\a\24\6=\6\25\0055\6\26\0004\a\0\0=\a\27\0065\a\28\0=\a\29\6=\6\30\0055\6\31\0005\a\"\0006\b \0'\n!\0B\b\2\2=\b#\a=\a\24\6=\6$\0055\6%\0=\6&\0055\6(\0005\a'\0=\a)\0065\a*\0=\a+\0065\a,\0005\b-\0=\b\24\a=\a.\6=\6/\0055\0060\0005\a1\0=\a\27\0065\a2\0=\a3\0064\a\0\0=\a4\6=\0065\0055\0066\0=\0067\5B\3\2\1K\0\1\0\frainbow\1\0\2\venable\2\18extended_mode\2\14highlight\20custom_captures&additional_vim_regex_highlighting\1\2\0\0\borg\1\2\0\0\borg\1\0\1\venable\2\rrefactor\17smart_rename\1\0\1\17smart_rename\15<leader>rr\1\0\1\venable\2\28highlight_current_scope\1\0\1\venable\1\26highlight_definitions\1\0\0\1\0\1\venable\2\vindent\1\0\1\venable\2\26incremental_selection\19init_selection\1\0\3\22scope_incremental\n<M-N>\21node_decremental\n<M-p>\21node_incremental\n<M-n>\14<leader>v\6t\1\0\1\venable\2\15playground\16keybindings\1\0\n\14goto_node\t<cr>\vupdate\6R\21unfocus_language\6F\19focus_language\6f\28toggle_language_display\6I\27toggle_anonymous_nodes\6a\30toggle_injected_languages\6t\21toggle_hl_groups\6i\24toggle_query_editor\6o\14show_help\6?\fdisable\1\0\3\15updatetime\3\25\venable\2\20persist_queries\1\17textsubjects\fkeymaps\1\0\3\6;!textsubjects-container-outer\ai;!textsubjects-container-inner\6.\23textsubjects-smart\1\0\2\19prev_selection\6,\venable\2\17query_linter\16lint_events\1\3\0\0\rBufWrite\15CursorHold\1\0\2\21use_virtual_text\2\venable\2\16treeclimber\1\0\1\venable\2\21ensure_installed\1\0\0\nfiles\1\3\0\0\17src/parser.c\19src/scanner.cc\1\0\2\rrevision\tmain\burl3https://github.com/MDeiml/tree-sitter-markdown\1\0\1\rfiletype\rmarkdown\rmarkdown\17install_info\1\0\2\rrevision\tmain\burl0https://github.com/milisims/tree-sitter-org\1\0\1\rfiletype\borg\borg\23get_parser_configs\28nvim-treesitter.parsers\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: orgmode.nvim
time([[Config for orgmode.nvim]], true)
try_loadstring("\27LJ\2\në\1\0\0\5\0\6\0\n6\0\0\0'\2\1\0B\0\2\2\18\2\0\0009\0\2\0005\3\4\0005\4\3\0=\4\5\3B\0\3\1K\0\1\0\21org_agenda_files\1\0\1\27org_default_notes_file\20~/notes/gtd.org\1\2\0\0\17~/notes/**/*\nsetup\forgmode\frequire\0", "config", "orgmode.nvim")
time([[Config for orgmode.nvim]], false)
-- Config for: zen-mode.nvim
time([[Config for zen-mode.nvim]], true)
try_loadstring("\27LJ\2\n]\0\0\5\0\6\0\b6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3D\1\2\0\fdimming\1\0\0\1\0\1\nalpha\4ö≥ÊÃ\tô≥Ê˛\3\nsetup\rzen-mode\frequire\0", "config", "zen-mode.nvim")
time([[Config for zen-mode.nvim]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\nÂ\1\0\0\2\0\b\0\0176\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0K\0\1\0\1\2\0\0\thelp&indent_blankline_filetype_exclude\1\2\0\0\b‚îÉ\31indent_blankline_char_list*indent_blankline_show_current_context$indent_blankline_use_treesitter\6g\bvim\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: twilight.nvim
time([[Config for twilight.nvim]], true)
try_loadstring("\27LJ\2\n]\0\0\5\0\6\0\b6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3D\1\2\0\fdimming\1\0\0\1\0\1\nalpha\4ö≥ÊÃ\tô≥Ê˛\3\nsetup\rtwilight\frequire\0", "config", "twilight.nvim")
time([[Config for twilight.nvim]], false)
-- Config for: emmet-vim
time([[Config for emmet-vim]], true)
try_loadstring("\27LJ\2\n=\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\n<c-y>\26user_emmet_leader_key\6g\bvim\0", "config", "emmet-vim")
time([[Config for emmet-vim]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType jsonnet ++once lua require("packer.load")({'vim-jsonnet'}, { ft = "jsonnet" }, _G.packer_plugins)]]
vim.cmd [[au FileType racket ++once lua require("packer.load")({'rainbow_parentheses.vim'}, { ft = "racket" }, _G.packer_plugins)]]
vim.cmd [[au FileType fennel ++once lua require("packer.load")({'fennel.vim'}, { ft = "fennel" }, _G.packer_plugins)]]
vim.cmd [[au FileType eelixer ++once lua require("packer.load")({'vim-elixir'}, { ft = "eelixer" }, _G.packer_plugins)]]
vim.cmd [[au FileType fish ++once lua require("packer.load")({'vim-fish'}, { ft = "fish" }, _G.packer_plugins)]]
vim.cmd [[au FileType elixir ++once lua require("packer.load")({'vim-elixir'}, { ft = "elixir" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]], false)
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/fennel.vim/ftdetect/fennel.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/fennel.vim/ftdetect/fennel.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/fennel.vim/ftdetect/fennel.vim]], false)
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-jsonnet/ftdetect/jsonnet.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-jsonnet/ftdetect/jsonnet.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-jsonnet/ftdetect/jsonnet.vim]], false)
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-elixir/ftdetect/elixir.vim]], true)
vim.cmd [[source /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-elixir/ftdetect/elixir.vim]]
time([[Sourcing ftdetect script at: /home/dylan/.local/share/nvim/site/pack/packer/opt/vim-elixir/ftdetect/elixir.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
