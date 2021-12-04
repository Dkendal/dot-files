(require-macros :projet.macros)

(local lume (require :lume))
(local toml (require :toml))
(local lpeg (require :lpeg))
(local stringx (require :pl.stringx))
(local tablex (require :pl.tablex))
(local seq (require :pl.seq))
(local V (require :projet.vim))

(local ex vim.cmd)
(local v vim.fn)

(local buffers {})
(local configs {})

(fn ins [...]
  (print (.. ((require :fennelview) ...) "\n"))
  ...)

(local join table.concat)

(global projet {})

(local bmap (partial vim.api.nvim_buf_set_keymap 0))

(fn map-blank [str]
  "Map empty strings to nil, everything else is passed through."
  (match str
    "" nil
    x x))

(fn with-logging [func]
  "Add a stacktrace to the function on error"
  (match [(xpcall func debug.traceback)]
    [false err] (error err)))

(fn find-config []
  (local opts ".;")
  (-?> (or (map-blank (v.findfile :projet.toml opts))
           (map-blank (v.findfile :.projet.toml opts)))
       (v.fnamemodify ":p")))

(fn read-config [file]
  (-> (with-open [fd (io.open file :r)]
        (fd:read :a))
      (toml.parse)))

;; TODO merge with link-filename
(fn get-linkfile [link matches]
  (string.format link.pattern (unpack matches)))

(fn replace-prefix [str prefix rep]
  (match [(string.find str prefix 1 true)]
    [start end] (.. rep (string.sub str (+ end 1)))
    _ str))

(fn set-links [config filename]
  "Set the links for the current file"
  (fn pred [rule]
    (local pat (assert rule.pattern))
    ;; Modify filename so that it appears relative to the root-dir
    (local filename
           (-> filename
               (v.fnamemodify ":p")
               (replace-prefix (.. vim.b.projet.root-dir "/") "")))
    (local matches [(string.match filename pat)])
    (when (-> (length matches) (> 0))
      (put-in vim.b.projet :rule-name rule.name)
      (each [_ link (ipairs (assert rule.links))]
        ;; Define commands for each link
        ;; TODO support multiple links
        (local linkfile (get-linkfile link matches))
        (put-in vim.b.projet :link linkfile)
        ;; TODO check if commmand exists
        (ex (.. "command! -buffer A" (.. " :e " linkfile)))
        (ex (.. "command! -buffer A" link.name (.. " :e " linkfile)))
        ;; TODO check if mapping exists
        (bmap :n :<leader>pa :<cmd>A<cr> {}))))

  (lume.match config.rules pred))

(fn buf-config []
  (local buf (. buffers (vim.api.nvim_get_current_buf)))
  (local config (. configs buf.config-file))
  {:present? (not= config nil) : config : buf})

(fn with-config [func]
  (local buf (vim.api.nvim_get_current_buf))
  (when (not (. buffers buf))
    (local config-file (find-config))
    (tset buffers buf {: config-file})
    (when config-file
      (local conf (read-config config-file))
      (local root (v.fnamemodify config-file ":p:h"))
      ;; Do some basic validation to make sure that required members are
      ;; present
      (assert conf (.. "configuration is missing required member \"rules\""
                       "\n" (vim.inspect conf)))
      (local filename
             (-> (v.expand "%:p")
                 (replace-prefix (.. root "/") "")))
      ;; Find the first matching rule
      (var rule nil)
      (each [_ value (ipairs conf.rules) :until rule]
        (match [(string.match filename value.pattern)]
          (where tokens (> (length tokens) 0)) (set rule {:conf value : tokens})
          _ false))
      (tset buffers buf :rule rule)
      (tset configs config-file {: conf : root}))
    ;; TODO Remove unused entries
    ;; (ex "au BufUnload,BufDelete <buffer>")
    )
  ;; Don't run the callback if there is not config present
  (local config (buf-config))
  (when config.present?
    (func config)))

(fn projet.status []
  (with-config ins))

(fn projet.edit_config []
  (with-config #(ex (.. ":e " (or (?. $1 :buf :config-file) :.projet.toml)))))

(fn projet.apply_template []
  (fn callback [config]
    (local template (?. config :buf :rule :conf :template))
    (when template
      ;; TODO apply tokens to template
      (vim.api.nvim_buf_set_lines 0 0 -1 true (stringx.split template "\n"))
      (set vim.opt_local.modified false)))

  (with-config (fn [config]
                 (vim.schedule (fn []
                                 (callback config))))))

(fn get-rules [config]
  "Access a config's rules"
  (?. config :config :conf :rules))

(fn get-root [config]
  "Access a config's root dir"
  (?. config :config :root))

;; TODO move to config
(local files-command "fd --full-path")

(fn find-by [tbl key value]
  "Find an item that makes the key's value"
  (match (tablex.find_if tbl #(= (. tbl key) value))
    (idx true) (. tbl idx)
    _ nil))

(fn find-rule [config name]
  "Find a rule by name"
  (find-by (get-rules config) :name name))

(fn find-link [config name]
  (find-by config.buf.rule.conf.links :name name))

(fn link-filename [config name]
  "Filename of link"
  (local link (find-link config name))
  (.. vim.b.projet.root-dir "/" (get-linkfile link config.buf.rule.tokens)))

(fn projet.goto_link [name]
  (-> (fn [config]
        (ex (string.format "e %s" (link-filename config name))))
      (with-config)))

(fn projet.list_files [rule-name]
  "List all files matching the rule's pattern"
  (-> (fn [config]
        (local root (get-root config))
        (local rule (find-rule config rule-name))
        ;; TODO remove debug statement
        (ins rule)
        (when rule
          (->> (vim.fn.systemlist (.. files-command " " root))
               (vim.tbl_filter #(string.match $1 rule.pattern))
               ;; TODO return values
               (ins))))
      (with-config)))

(fn projet.detect []
  (-> (fn []
        (local config-file (find-config))
        (when config-file
          (local root-dir (v.fnamemodify config-file ":p:h"))
          (set vim.b.projet {: root-dir : config-file})
          ;; Create command to change directory to where to config file is located
          (ex (.. "command! -buffer Cd :cd " root-dir))
          (ex (.. "command! -buffer Lcd :lcd " root-dir))
          (ex (.. "command! -buffer Tcd :tcd " root-dir))
          (local config (read-config config-file))
          (put-in vim.b.projet :config config)
          (assert config.rules ;;
                  (.. "configuration is missing required member \"rules\"" "\n"
                      (vim.inspect vim.b.projet)))
          (set-links config (v.bufname))))
      (with-logging)))

(fn projet.init []
  (ex "
      command! ProjetConfig :lua require('projet').edit_config()
      command! ProjetStatus :lua require('projet').status()
      command! -nargs=1 ProjetLink :lua require('projet').goto_link()
      command! -nargs=* ProjetList :lua require('projet').list_files(<f-args>)

      augroup projet
      autocmd!
      autocmd BufEnter * lua require('projet').detect()
      autocmd BufNewFile * lua require('projet').apply_template()
      augroup END
      "))

projet

