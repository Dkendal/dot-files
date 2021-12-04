;; Main API
;; TODO: move file to be the index or something

(require-macros :viper.vim-macro)

(local fzf (require :fzf))
(local util (require :viper.util))
(local a (require :viper.async))
(local remote (require :viper.remote))
(local debounce (. (require :viper.timers) :debounce))
(local api vim.api)

(local mod {})

(fn present? [term]
  "Test if term is not the empty string or nil"
  (and (not= term "") (not= term nil)))

(fn blank? [term]
  "Test if term is the empty string or nil"
  (not (present? term)))

(fn match-error [value]
  (error (.. "No matching case for: " (vim.inspect value))))

(fn cmd [...]
  "Vim cmd"
  (vim.cmd (table.concat [...] " ")))

(fn log [...]
  "Log a message to a special [Lua Messages] buffer"
  (local buf (vim.fn.bufadd "[Lua Messages]"))
  (local objects (vim.tbl_map vim.inspect [...]))
  (local str (table.concat objects " "))
  (local lines (vim.split str "\n"))
  (a.main #(vim.api.nvim_buf_call buf
                                  #(do
                                     (set vim.bo.buflisted true)
                                     (set vim.bo.swapfile false)
                                     (set vim.bo.buftype :nofile)
                                     (vim.api.nvim_buf_set_lines 0 -1 -1 false
                                                                 lines)
                                     (local n (vim.api.nvim_buf_line_count 0))
                                     (vim.api.nvim_win_set_cursor 0 [n 0]))))
  ...)

(fn merge-fzf-opts [opts]
  (util.tbl2flags (vim.tbl_deep_extend :force
                                       {:ansi true :color vim.o.background} opts)))

(fn exec-list [vim-expr]
  "Execute a vim expression, returning captured result as a list."
  (-> vim-expr
      (api.nvim_exec true)
      (vim.split "[\n\r]")))

(fn parse-fn [pattern]
  "Extact a file location from a string"
  (fn [text]
    (local (file line col) (text:match pattern))
    [file (tonumber line) (tonumber col)]))

(fn parse-ls [text]
  "extract the filename out of :ls"
  (local file (text:match "(%d+).*"))
  file)

(fn parse-vimgrep [text]
  "extract a file linenum and colnum from a vimgrep output"
  (local (file line col) (text:match "^(.+):(%d+):(%d+):"))
  [file (tonumber line) (tonumber col)])

(fn result-get [result]
  "Return the success value of a result, or throw an error."
  (match result
    [false reason] (error reason)
    [true value] value))

(fn with-cursor [func]
  "Restore buffer position after func completes"
  (let [view (vim.fn.winsaveview)
        buf (api.nvim_get_current_buf)
        win (api.nvim_get_current_win)]
    (local result [(pcall func)])
    (api.nvim_set_current_win win)
    (api.nvim_set_current_buf buf)
    (vim.fn.winrestview view)
    (result-get result)))

(fn with-temp-buf [func]
  "Execute func in a temporary buffer"
  (with-cursor (fn []
                 (local buf (api.nvim_create_buf false true))
                 (vim.cmd (.. "botright sb " buf))
                 (api.nvim_win_set_height 0 10)
                 (set vim.wo.number false)
                 (set vim.wo.signcolumn :no)
                 (local result [(pcall func)])
                 (when (api.nvim_buf_is_valid buf)
                   (api.nvim_buf_delete buf {}))
                 (result-get result))))

(local sink-file {})
(set sink-file.expect [:ctrl-y :ctrl-t :ctrl-v :ctrl-s :enter])
(fn sink-file.callback [result]
  (match result
    [:ctrl-y [file]] (with-main (vim.fn.setreg "+" file)
                                (vim.fn.setreg "*" file))
    [:ctrl-t [file]] (cmd :tabe file)
    [:ctrl-v [file]] (cmd :vertical :split file)
    [:ctrl-s [file]] (cmd :split file)
    [:enter [file]] (cmd :e file)))

(fn run-fzf [opts]
  "
  Params

  opts.fzf-opts?: map - Flags to pass to FZF
  opts.process?: (string -> T) - Preprocessing to apply to the selection
  opts.sink?: ([string T] -> void) - Callback for final selection
  opts.config?: (-> void) - Callback that is run in the temp buffer, before FZF
  is called
  opts.on-change: (T -> void) - Callback to preview a selection while FZF is
  active
  "
  (local fzf-opts (-> opts.fzf-opts
                      (or {})
                      (merge-fzf-opts)))
  (local sink opts.sink)
  (local source opts.source)

  (fn current-line []
    (local pattern "> (.*)")
    (var out nil)
    (each [k v (ipairs (api.nvim_buf_get_lines 0 0 -3 false)) :until out]
      (local m (string.match v pattern))
      (when m
        (set out m)))
    out)

  (fn selection-change [raw-line]
    (when opts.on-change
      (local current-line (if opts.process
                              (opts.process raw-line)
                              raw-line))
      (when current-line
        (with-main (set vim.b.viper-raw-current-line raw-line)
                   (set vim.b.viper-current-line current-line)
                   (opts.on-change current-line)))))

  (fn body []
    "Any setup to run before running but within the temp buffer"
    (buf-map :t :<ESC> :<C-c>)
    (when opts.config
      (opts.config))
    ;; Call the on-change function when the line chagnes, debounced.
    (util.on_selection_change (debounce 100 selection-change))
    (-> (match source
          [:shell shellcmd] shellcmd
          [:vim expr] (exec-list expr)
          _ (match-error _)) ; Run fzf as an external command
        (fzf.provided_win_fzf fzf-opts)))

  (fn call []
    (-> body
        (with-temp-buf) ; Result of fzf is fed to sink
        (match ; If the process callback is supplied transform the value by it
          (where [key selection] opts.process)
          [key (opts.process selection)]
          k
          k)
        (sink)))

  (a.main (a.sync call)))

(fn mod.history []
  ""
  (run-fzf {:source [:vim :oldfiles]
            :process #($1:match "^%d+: (.*)")
            :fzf-opts {:expect sink-file.expect}
            :sink sink-file.callback}))

(fn mod.files [source ?opts]
  "
  @param source [string] Shell command that returns a file path
  @param opts.pattern [string]
  @param opts.process [(string -> [string number number])]
  "
  (local opts (or ?opts {}))
  (var process (match [opts.pattern opts.process]
                 [nil nil] #[$1]
                 [nil process] process
                 [pattern _] (parse-fn pattern)))
  (run-fzf {:source [:shell source]
            : process
            :fzf-opts {:expect sink-file.expect}
            :sink sink-file.callback}))

(fn mod.grep [source ?opts]
  "
  Params

  source: string - Shell command that returns vimgrep compatible output
  opts?: map - unused
  "
  (local opts (or ?opts {}))
  (local ns (api.nvim_create_namespace "Viper Grep"))
  (local hl-group :Search)
  (local win (api.nvim_get_current_win))
  (var buf 0)

  (fn clear-highlight [buf]
    (api.nvim_buf_clear_namespace buf ns 0 -1))

  (fn on-change [[file line col]]
    (set buf (vim.fn.bufadd file))
    (with-main (clear-highlight buf))
    (if (and file line)
        (with-main ; Highlight selection
                   (api.nvim_buf_add_highlight buf ns hl-group (- line 1) 0 -1)
                   ; Change window to selected buffer
                   (api.nvim_win_set_buf win buf)
                   ; Add on buf leave clear namespace
                   (with-buf buf ; Move cursor to selection, center screen
                             (vim.fn.setpos "." [buf line col])
                             (cmd "keepjumps normal zz")
                             ; Reload the filetype if it's not set
                             (when (blank? vim.bo.filetype)
                               (cmd "filetype detect"))))))

  (fn sink [resp]
    (match resp
      [:enter [file line _]] (do
                               (cmd :e (.. "+" line) file)
                               (cmd :keepjumps :normal :zz))) ; clean up
    (clear-highlight))

  (run-fzf {:source [:shell source]
            :process parse-vimgrep
            : on-change
            :fzf-opts {:expect [:enter]}
            : sink}))

(fn mod.buffers []
  ;; TODO some way to reload buffer contents

  (fn on-change [buf]
    ;; (bmap "t" "<c-k>" (.. "<cmd>bd " buf " <cr>"))
    )

  (local opts {:source [:vim :ls]
               :fzf-opts {:expect [:enter]}
               :process parse-ls
               : on-change
               :sink #(match $1
                        [:enter selection] (cmd :b selection))})
  (run-fzf opts))

mod

