;; Vim helpers

(local S (require :projet.string))
(local lume (require :lume))

(fn au [opts]
  (local group (or opts.group ""))
  (local event (-> (assert opts.event ".event is required") (table.concat ",")))
  (local pat (assert opts.pat ".pat is required"))
  (local once (if opts.once :++once ""))
  (local nested (if opts.nested :++nested ""))
  (local cmd (assert opts.cmd ".cmd is required"))
  (-> [:au group event pat once nested cmd]
      (lume.reject #(= $1 ""))
      (table.concat " ")))

(fn augroup [groupname rules]
  (local rulestrings
         (lume.map rules #(if (-> $1 (type) (= :table)) (au $1) $1)))
  (-> [(.. "augroup " groupname) (table.concat rulestrings "\n") "augroup END"]
      (table.concat "\n")
      (vim.api.nvim_exec true)))

(fn luaeval [luaexpr vimexpr]
  (string.format "call luaeval(\"%s\", %s)" (S.escape luaexpr "\"") vimexpr))

{: au : augroup : luaeval}

