(local mod {})

(fn mod.put-in [expr key value]
  `(do
     (local state# ,expr)
     (tset state# ,key ,value)
     (set ,expr state#)))

(fn mod.t [key]
  `(vim.api.nvim_replace_termcodes ,key true true true))

(fn mod.alias [term]
  "Define a local with the same name as the last property"
  (local pattern ".*%.(.*)")
  (local head (-> term (. 1) (string.match pattern) (sym)))
  `(local ,head ,term))

mod

