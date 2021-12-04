(local mod {})

(fn mod.ex [...]
  `(vim.cmd ,...))

(fn mod.t [key]
  `(vim.api.nvim_replace_termcodes ,key true true true))

(fn mod.map [mode lhs rhs ?opts]
  `(vim.api.nvim_set_keymap ,mode ,lhs ,rhs (or ,?opts {})))

(fn mod.bmap [mode lhs rhs ?opts]
  `(vim.api.nvim_buf_set_keymap 0 ,mode ,lhs ,rhs (or ,?opts {})))

(fn mod.abbr [mode mapping]
  "Define multiple abbreviations"
  (local arr [])
  (each [k v (pairs mapping)]
    (var cmd :abbr)
    (match mode
      :c (set cmd :cabbr))
    (table.insert arr `(vim.cmd (.. ,cmd " " ,k " " ,v))))
  `(do
     ,(unpack arr)))

(fn mod.alias [term]
  "Define a local with the same name as the last property"
  (local pattern ".*%.(.*)")
  (local head (-> term (. 1) (string.match pattern) (sym)))
  `(local ,head ,term))

(fn mod.use [name ?opts]
  (local opts (or ?opts {}))
  (tset opts 1 name)
  `(packer.use ,opts))

mod

