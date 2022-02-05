(require-macros :macros)

(local {: register} (require :which-key))

;; Plugins

;; Comment.nvim
(do
  (map :o "<leader>;" ":Commentary<CR>")
  (map :v "<leader>;" ":Commentary<CR>")
  (map :n "<leader>;" ":Commentary<CR>"))

;; Plugins/vim-test
(do
  (map :n :<leader>tl :<cmd>TestLast<cr>)
  (map :n :<leader>tf :<cmd>TestFile<cr>)
  (map :n :<leader>tt :<cmd>TestNearest<cr>))

;; Plugins/vim-sandwich
(do
  (map :n :s :<nop>)
  (map :x :s :<nop>))

;; Gitsigns
(do
  (map :n :<leader>gb "<cmd>Gitsigns blame_line<cr>"
       {:nowait true :noremap true :silent true}))

;; Plugins/symbols-outline
(do
  (map :n :<leader>o :<cmd>SymbolsOutline<cr>
       {:noremap true :nowait true :silent true}))

;; Plugins/compe
(do
  (local opts {:noremap true :expr true :silent true})
  ;; (map :i :<C-space> "compe#complete()" opts)
  ;; (map :i :<cr> "compe#confirm('<CR>')" opts)
  ;; (map :i :<c-j> "compe#confirm('<c-j>')" opts)
  ;; (map :i :<C-e> "compe#close('<C-e>')" opts)
  )

;; Plugins/nvim-viper
(do
  (map :v :<leader>/ ":y:<C-u>:ViperGrep rg --vimgrep -w -- <C-r>0<CR>")
  (map :n :<leader>bb ":ViperBuffers<cr>"))

(map :n :<m-h> "<cmd>lua require('treeclimber.internal').move_to_prev()<cr>")
(map :n :<m-k> "<cmd>lua require('treeclimber.internal').move_to_parent()<cr>")
(map :n :<m-j> "<cmd>lua require('treeclimber.internal').move_to_first_child()<cr>")
(map :n :<m-l> "<cmd>lua require('treeclimber.internal').move_to_next()<cr>")

(local ts (require :telescope.builtin))

(register
  {:f {:name :Files
       :f [#(ts.find_files {:find_command ["fd"]}) "Find files"]
       :F [#(ts.find_files {:find_command ["fd" "-u"]}) "Find files w/ hidden"]}

   :<leader> ["<cmd>Telescope commands<cr>"]

   :s {:s [#(ts.current_buffer_fuzzy_find) "Search current buffer"]}

   :p {:r [":ViperRegisters<cr>" :Registers]
       :f [#(ts.git_files) "Git files"]
       :g [":ViperGitStatus<cr>" "Git status"]}

   :h {:name "Vim"
       :h ["<cmd>Telescope help_tags<cr>" "Help tags"]
       :m ["<cmd>Telescope man_pages<cr>" "Help tags"]

       :d {:name "Describe"
           :f ["<cmd>P! function<cr>" "Functions"]
           :v ["<cmd>P! verbose let<cr>" "Variables"]
           :m ["<cmd>Telescope keymaps<cr>" "Keymaps"]}

       :r {:name "Vim Runtime"
           :r ["<cmd>Telescope reloader<cr>" "Reloader"]
           :/ [#(ts.live_grep {:cwd (vim.fn.stdpath :config)}) "Search Vim config"]
           :? [#(ts.live_grep {:cwd (vim.fn.stdpath :data)}) "Search Vim data"]
           :l [#(ts.find_files {:cwd (vim.fn.stdpath :config)}) "Vim config files"]
           :L [#(ts.find_files {:cwd (vim.fn.stdpath :data)}) "Vim data files"]}}}
  {:prefix :<leader>})

;; Plugins/fzf.vim
(do
  (map :n :<leader>pm ":Marks<cr>")
  (map :n :<leader>ww ":Windows<cr>")
  (map :n :<expr> "<leader>* '<cmd>Rg!<space>'.expand('<cword>').'<cr>'")
  )

;; Plugins/telescope
(do
  (map :n :<leader>/ "<cmd>Telescope live_grep<cr>")
  (map :n :<leader>fr "<cmd>Telescope oldfiles<CR>")
  (map :n :<leader>gla "<cmd>Telescope git_commits<cr>")
  (map :n :<leader>glb "<cmd>Telescope git_bcommits<cr>")
  (map :n :<leader>lca "<cmd>Telescope lsp_code_actions<cr>")
  (map :n :<leader>lds "<cmd>Telescope lsp_document_symbols<cr>")
  (map :n :<leader>ldws "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>")
  (map :n :<leader>lwd "<cmd>Telescope lsp_workspace_diagnostics<cr>")
  (map :n :<leader>lws "<cmd>Telescope lsp_workspace_symbols<cr>"))

;; Trouble.nvim
(do
  (map :n :<space>q "<cmd>TroubleToggle workspace_diagnostics<CR>"
       {:silent true})
  (map :n :<space>q "<cmd>TroubleToggle document_diagnostics<CR>"
       {:silent true}))

;; Plugins/zen
(do
  (map :n :<leader>tF ":ZenMode<cr>" {:silent true})
  (map :n :<leader>tf ":Twilight<cr>" {:silent true}))

;; Plugins/vim-unimpaired
;; Remaps for vim-unimpaired and toggles
(each [_ key (ipairs [:b :c :d :h :i :l :n :r :s :u :v :w :x])]
  (map :n (.. :<leader>t key) (.. :yo key)))

;; User
; c-[ escapes to normal mode in the terminal
(map :t "<c-[>" "<c-\\><c-n>")

; jump to start of { or }
(map "" "[[" "?{<CR>w99[{")
(map "" "][" "/}<CR>b99]}")
(map "" "]]" "j0[[%/{<CR>")
(map "" "[]" "k$][%?}<CR>")

;; Windows
(map :n :<leader>w :<c-w>)
(map :n :<leader>wd ":q<cr>")
(map :n :<leader>wn ":tabe<cr>")
(map :n :<up> :<c-w>+)
(map :n :<down> :<c-w>-)
(map :n :<left> :<c-w>=)

;; Buffers
(map :n :<leader>bd ":bp<cr>:bd #<cr>")

(map :n :<leader>feR ":Runtime<cr>")
(map :n :<leader>fed "~/.config/nvim/fnl/config.fnl<cr>")

(map :n :<leader>fyy ":let @+=expand('%')<cr>:let @*=@+<cr>")
(map :n :<leader>fyp ":let @+=expand('%:p')<cr>:let @*=@+<cr>")
(map :n "<leader>fy~" ":let @+=expand('%:~')<cr>:let @*=@+<cr>")
(map :n :<leader>fyt ":let @+=expand('%:t')<cr>:let @*=@+<cr>")
(map :n :<leader>fyl ":let @+=expand('%') . ':' . line('.')<cr>:let @*=@+<cr>")
(map :n :<leader>ay
     ":let @+='[[' . expand('%:~') . '::' . line('.') . ']]'<cr>:let @*=@+<cr>:echo @*<cr>")

;; Command mode readline
(map :c :<C-a> :<Home>)
(map :c :<C-e> :<End>)
(map :c :<C-p> :<Up>)
(map :c :<C-n> :<Down>)
(map :c :<C-b> :<Left>)
(map :c :<C-f> :<Right>)
(map :c :<M-b> :<S-Left>)
(map :c :<M-f> :<S-Right>)

;; Maintain selection
(map :v ">" :>gv)
(map :v "<" :<gv)

;; (map :n "<M-n>" "vl<M-n>")

;; Re-run macro on visual selection
(map :x "@@" ":normal@@<cr>")

;; Fold everything then open folds under cursor
(map :n :<leader>zF :zMzv)

(map :n :<leader>e ":e <c-r>=expand('%:h')<cr>")

(map :n "-" ":Explore<cr>" {:silent true})

(map :n :<leader>tb ":lua require('background').toggle()<cr>" {:silent true})

(ex "
    \" Expand
    imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
    smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

    \" Expand or jump
    imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
    smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

    \" Jump forward or backward
    imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
    smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
    imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
    smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

    \" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
    \" See https://github.com/hrsh7th/vim-vsnip/pull/50
    xmap        <C-L>   <Plug>(vsnip-cut-text)
    \"nmap        S   <Plug>(vsnip-cut-text)
    \"xmap        S   <Plug>(vsnip-cut-text)
    ")

(local wk (require :which-key))
(local which-key wk.register)

(which-key {})

