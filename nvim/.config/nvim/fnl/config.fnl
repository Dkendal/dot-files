(require-macros :macros)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Boilerplate                                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global plugins {})
(global hooks {})

(global inspect (require :fennelview))

(global p #(print (inspect $...)))

(local packer (require :packer))

(local use-rocks packer.use_rocks)

(packer.init {:ensure_dependencies true})
(packer.reset)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lua rocks                                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-rocks :lua-toml {:ft [:toml]})
(use-rocks :penlight)
(use-rocks :lpeg)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Plugins                                                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use :wbthomason/packer.nvim)

(use :nathom/filetype.nvim
     {:config (fn []
                (: (require :filetype) :setup
                   {:overrides {:extensions {}
                                :literal {}
                                :complex {}
                                :function_extensions {}
                                :function_literal {}
                                :function_complex {}}}))})

(use :tweekmonster/startuptime.vim {:commands [:StartupTime]})

;; Colorschemes
(use :morhetz/gruvbox)
(use :rktjmp/lush.nvim)

;; Filetypes
(use :wlangstroth/vim-racket)
(use :fgsch/vim-varnish)
(use :neoclide/jsonc.vim)
(use :bakpakin/fennel.vim {:ft [:fennel]})
(use :blankname/vim-fish {:ft [:fish]})
(use :google/vim-jsonnet {:ft [:jsonnet]})
(use :pld-linux/vim-syntax-vcl)

(use :earthly/earthly.vim {:branch :main})

(use :elixir-editors/vim-elixir
     {:ft [:elixir :eelixer] :config #(plugins.vim-elixir)})

(use :jparise/vim-graphql)
(use :leafgarland/typescript-vim)
(use :kristijanhusak/orgmode.nvim
     { :config #(: (require :orgmode) :setup
                  {:org_agenda_files ["~/notes/**/*"]
                   :org_default_notes_file "~/notes/gtd.org"})})

(use :nvim-telescope/telescope-fzf-native.nvim {:run :make})

(use :nvim-telescope/telescope.nvim
     {:requires [[:nvim-lua/plenary.nvim]]
      :config #(do
                 (local mod (require :telescope))
                 (mod.setup {:extensions {:fzf {}}})
                 (mod.load_extension :fzf))})

; Vim unit testings
(use :junegunn/vader.vim)
(use :janko-m/vim-test)

; tpope
(use :tpope/vim-speeddating)
(use :tpope/vim-abolish)
(use :tpope/vim-commentary)

(use :tpope/vim-eunuch)
(use :tpope/vim-fugitive)
(use :tpope/vim-repeat)
(use :tpope/vim-rhubarb)
(use :tpope/vim-rsi)
(use :tpope/vim-scriptease)
(use :tpope/vim-sleuth)
(use :tpope/vim-vinegar)
(use :tpope/vim-unimpaired)

(use :simrat39/symbols-outline.nvim {:config #(plugins.symbols-outline)})

(use :glepnir/galaxyline.nvim
     {:branch :main
      :requires :kyazdani42/nvim-web-devicons
      :config #((require :user.statusline))})

(use :KabbAmine/vCoolor.vim)
(use :chrisbra/Colorizer)
(use :godlygeek/tabular)
(use :machakann/vim-sandwich)

; (use :AndrewRadev/splitjoin.vim)
(use :artnez/vim-wipeout)
(use :bogado/file-line)
(use :jamessan/vim-gnupg)
;; File formatter
(use :mhartington/formatter.nvim {:config #(require :user.formatter)})

;; Emacs like narrowing
(use :chrisbra/NrrwRgn)
;; Icons for status line

(use :ryanoasis/vim-devicons)
(use :kyazdani42/nvim-web-devicons)

(use :onsails/lspkind-nvim)

(use :hrsh7th/vim-vsnip
     {:config #(do
                 (local vsnip_filetypes {:jsonc [:json]})
                 (local vsnip_filetypes {:typescript [:javascript]})
                 (set vim.g.vsnip_filetypes vsnip_filetypes))})

(use :hrsh7th/vim-vsnip-integ)
(use :hrsh7th/cmp-nvim-lsp)
(use :hrsh7th/cmp-buffer)
(use :hrsh7th/cmp-path)
(use :hrsh7th/cmp-vsnip)
(use :hrsh7th/cmp-nvim-lua)
(use :hrsh7th/cmp-calc)
(use :hrsh7th/cmp-emoji)
(use :tzachar/cmp-tabnine
     {:run :./install.sh
      :config #(do
                 (local tabnine (require :cmp_tabnine.config))
                 (tabnine:setup {:max_lines 1000
                                 :max_num_results 20
                                 :sort true
                                 :run_on_every_keystroke true}))})

(use :hrsh7th/nvim-cmp {:config #(plugins.cmp)})

;; Language Server
(use :nvim-lua/lsp-status.nvim)

(use :folke/trouble.nvim {:requires :kyazdani42/nvim-web-devicons
                          :config #(plugins.trouble)})

(use :folke/zen-mode.nvim
     {:config (fn []
                (local zen-mode (require :zen-mode))
                (zen-mode.setup {:dimming {:alpha 0.4}}))})

(use :folke/twilight.nvim
     {:config (fn []
                (local twilight (require :twilight))
                (twilight.setup {:dimming {:alpha 0.4}}))})

(use :folke/which-key.nvim
     {:config (fn []
                (local wk (require :which-key))
                (wk.setup {}))})

(use :neovim/nvim-lspconfig
     {:requires [:lsp-status.nvim]
      :config (fn []
                (require :init-lspconfig))})

;; Tree sitter
(use :nvim-treesitter/nvim-treesitter
     {:run ":TSUpdate" :config #(require :user.treesitter)})

(use :nvim-treesitter/playground
     {:commands [:TSPlaygroundToggle :TSHighlightCapturesUnderCursor]})

(use :nvim-treesitter/nvim-treesitter-textobjects)

(use :romgrk/nvim-treesitter-context)

(use :p00f/nvim-ts-rainbow {:before [:nvim-treesitter/nvim-treesitter]})

(use :mattn/emmet-vim
     {:config (fn []
                (set vim.g.user_emmet_leader_key :<c-y>))})

(use :mg979/vim-visual-multi
     {:branch :master
      :config (fn []
                (set vim.g.VM_theme :paper))})

(use :lukas-reineke/indent-blankline.nvim
     {:branch :master :config #(plugins.indent-blankline)})

(use :lewis6991/gitsigns.nvim
     {:requires [:nvim-lua/plenary.nvim]
      :tag :v0.2
      :config #(plugins.gitsigns)})

(use :raghur/vim-ghost {:run ":GhostInstall"})

;; FZF
(use :junegunn/fzf {:run "./install --all"})

(use :junegunn/fzf.vim {:requires [:junegunn/fzf]})

(use :vijaymarupudi/nvim-fzf {:commit :3a08f00 :frozen true})

;; Packs
(ex "packadd! cfilter")
(ex "packadd! matchit")
(ex "packadd! nvim-gh")
(ex "packadd! nvim-minor-mode")
(ex "packadd! nvim-projet")
(ex "packadd! nvim-viper")
(ex "packadd! nvim-treeclimber")

(init.update_fennel_runtime_path)

(require :treeclimber)
(local {: define-minor-mode} (require :minor-mode))

(define-minor-mode :lisp "Sexp based movement for lisps"
                   {:command :LispMode
                    :keymap [[:n :j #(vim.fn.search "[(\\[{]") {:silent true}]
                             [:n
                              :k
                              #(vim.fn.search "[(\\[{]" :b)
                              {:silent true}]
                             [:n :J #(vim.fn.search "[)\\]}]") {:silent true}]
                             [:n
                              :K
                              #(vim.fn.search "[)\\]}]" :b)
                              {:silent true}]]})

;; (define-minor-mode :increment-selection "Treesitter incremental selection mode"
;;                    {:command :IncrementalSelectionMode
;;                     :keymap [[
;;                               ;; :n "<leader>v" #((require :))]
;;                              ;; TODO add hook to call init_selection
;; [:x :p ":lua require'nvim-treesitter.incremental_selection'.node_decremental()<CR>"]
;; [:x :N ":lua require'nvim-treesitter.incremental_selection'.scope_incremental()<CR>"]
;; [:x :n ":lua require'nvim-treesitter.incremental_selection'.node_incremental()<CR>"]
;;                              ]})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Options                                                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set vim.o.shell :bash)
(set vim.o.cedit :<C-O>)
(set vim.o.cinoptions "1s,(0,W2,m1")
(set vim.o.makeef :errors.err)
(set vim.o.clipboard "unnamedplus,unnamed")
(set vim.o.foldmethod :indent)
; (set vim.o.foldmethod "expr")
; (set vim.o.foldexpr "nvim_treesitter#foldexpr()")
(set vim.o.foldlevel 99)
(set vim.o.grepprg "rg --vimgrep")
(set vim.o.includeexpr "asubstitute(v:fname,'[ab]/','./','g')")
(set vim.o.hidden true)
(set vim.o.timeoutlen 400)

(set vim.o.showbreak "↳")
(set vim.o.wrap false)
(set vim.o.breakindent true)
(set vim.o.colorcolumn :80)
(set vim.o.list true)
;; (set vim.o.listchars "tab:\│\ ,trail:•,nbsp:%,precedes:<,extends:>")

(set vim.o.mouse :a)
(set vim.o.synmaxcol 3000)

(set vim.o.undofile true)

(set vim.o.wildignorecase true)
(set vim.o.wildmenu true)
(set vim.o.wildmode "longest:full,full")

(set vim.o.expandtab true)
(set vim.o.lazyredraw true)

(set vim.o.hlsearch true)
(set vim.o.ignorecase true)
(set vim.o.inccommand :split)
(set vim.o.incsearch true)
(set vim.o.magic true)
(set vim.o.smartcase true)

(set vim.o.shiftwidth 2)
(set vim.o.tabstop 2)

(set vim.o.termguicolors true)

(set vim.o.completeopt "menu,menuone,noselect")

(set vim.o.cp false)

(set vim.wo.number true)

(set vim.g.vimsyn_embed :lmpPr)
(set vim.g.mapleader " ")
(set vim.g.maplocalleader ",")

(ex "filetype plugin indent on")
(ex "syntax on")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Commands                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(ex "command! -nargs=1 Fnl :lua print(vim.inspect(require('fennel').eval(<f-args>)))")
(ex "command! HiTest :so $VIMRUNTIME/syntax/hitest.vim")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Abbreviations                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(vim.api.nvim_exec "
  cabbr bda Wipeout
  cabbr V Verbose
  cabbr H Helptags
  cabbr <expr> R 'Rename '.expand('%:t')
  cabbr <expr> @% expand('%')
  cabbr <expr> @%p expand('%:p')
  cnoreabbrev ~~ ~/code/github.com/Dkendal/
 
  abbr overide override
  abbr acount account
  abbr resouces resources
  abbr teh the
  abbr <expr> d@ strftime('%Y-%m-%d')
  abbr <expr> D@ strftime('%Y-%m-%d %a')
  abbr <expr> ts@ strftime('%Y-%m-%d %a %k:%M')
  abbr <expr> t@ strftime('%Y%m%d%k%M')
  abbr <expr> us@ strftime('%s')
 
  iabbr docu document
  iabbr dont don't
  iabbr dnt don't
  iabbr abbr abbreviation
  iabbr abbrs abbreviations
  iabbr descr description
  " false)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Plugin configuration                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(fn plugins.indent-blankline []
  (set vim.g.indent_blankline_use_treesitter true)
  (set vim.g.indent_blankline_show_current_context true)
  (set vim.g.indent_blankline_char_list ["┃"])
  (set vim.g.indent_blankline_filetype_exclude [:help]))

(fn plugins.trouble []
  (: (require :trouble) :setup))

(fn plugins.cmp []
  (local cmp (require :cmp))
  (local lspkind (require :lspkind))

  (fn format [entry vim-item]
    "lspkind formatting"
    (set vim-item.kind (. lspkind.presets.default vim-item.kind))
    vim-item)

  (fn expand [args]
    "snippet expansion"
    ((. vim.fn "vsnip#anonymous") args.body))

  (local mapping {:<C-y> (cmp.mapping.confirm {:select true})
                  :<C-Space> (cmp.mapping.complete)
                  :<C-d> (cmp.mapping.scroll_docs -4)
                  :<C-u> (cmp.mapping.scroll_docs 4)
                  :<CR> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace
                                              :select true})})
  (local config {:snippet {: expand}
                 : mapping
                 :formatting {: format}
                 :sources [{:name :nvim_lsp}
                           {:name :nvim_lua}
                           {:name :vsnip}
                           {:name :orgmode}
                           ;; {:name :buffer}
                           {:name :path}
                           {:name :nvim_lua}
                           {:name :emoji}
                           {:name :orgmode}
                           {:name :cmp_tabnine}
                           {:name :calc}]})
  (cmp.setup config))

(fn plugins.symbols-outline []
  (set vim.g.symbols_outline {:highlight_hovered_item true
                              :show_guides true
                              :auto_preview true
                              :position :right
                              :show_numbers false
                              :show_relative_numbers false
                              :show_symbol_details true
                              :keymaps {:close :<Esc>
                                        :goto_location :<Cr>
                                        :focus_location :o
                                        :hover_symbol :<C-space>
                                        :rename_symbol :r
                                        :code_actions :a}
                              :lsp_blacklist {}}))

(fn plugins.gitsigns []
  (local gitsigns (require :gitsigns))
  (gitsigns.setup {:watch_index {:interval 1000}
                   :signs {:add {:hl :GitSignsAdd
                                 :text "│"
                                 :numhl :GitSignsAddNr
                                 :linehl :GitSignsAddLn}
                           :change {:hl :GitSignsChange
                                    :text "│"
                                    :numhl :GitSignsChangeNr
                                    :linehl :GitSignsChangeLn}
                           :delete {:hl :GitSignsDelete
                                    :text "_"
                                    :numhl :GitSignsDeleteNr
                                    :linehl :GitSignsDeleteLn}
                           :topdelete {:hl :GitSignsDelete
                                       :text "‾"
                                       :numhl :GitSignsDeleteNr
                                       :linehl :GitSignsDeleteLn}
                           :changedelete {:hl :GitSignsChange
                                          :text "~"
                                          :numhl :GitSignsChangeNr
                                          :linehl :GitSignsChangeLn}}}))

(fn plugins.vim-elixir []
  (set vim.g.filetype_euphoria :elixir)
  (set vim.g.elixir_use_markdown_for_docs true))

(require :projet)

(let [gh (require :gh)]
  (gh.setup))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hooks                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Modify the colorscheme when it is changed
(fn hooks.color-scheme []
  (ex "
      hi! link LspDiagnosticsDefaultHint GruvboxBg4
      hi Comment gui=italic cterm=italic
      ")
  ((require :user.statusline)))

(fn hooks.after-init [])

(ex "augroup user")
(ex :au!)
(ex "au! ColorScheme * lua hooks['color-scheme']()")

(if (= vim.v.vim_did_enter 1)
    (hooks.after-init)
    (ex "au SourcePost ++once packer_compiled.vim lua hooks['after-init']()"))

(ex "augroup END")

(ex "runtime macros/sandwich/keymap/surround.vim")

(require :globals)
(require :keymaps)
(require :boxes)
(require :background)

(set vim.g.gruvbox_contrast_dark :hard)

(ex "colorscheme gruvbox")

(set vim.o.exrc true)
(set vim.o.secure true)

