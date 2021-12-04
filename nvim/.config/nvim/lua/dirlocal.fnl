;; check the local directory on directory change or start up
;; is there a .vimlocal or something file
;; if there is read the value
;; check hash of file against value stored in ~/.local/share/nvim/dirlocal.lua or fnl
;; if value matches load
;; else prompt to load
;; else promt to permit

;; OR have a project file in this dir that has configs
(var fun (require :fun))

;; Mapping for paths to variables
(var config {})

;;
;; Private
;;

;;
;; Public Api
;;
(local dirlocal {})

(fn dirlocal.dirchanged [event]
  "DirChanged auto command handler

  event.changed_window :: bool
  event.cwd            :: string
  event.scope          :: 'window' | 'global' | 'tab'
  "
  (inspect event))

(fn dirlocal.setup [conf]
  "Configure variables for specific paths"
  (set config conf))

(fn dirlocal.get_config []
  "Configure variables for specific paths"
  config)

(fn augroup [name ...]
  (vim.api.nvim_exec
    (table.concat
      [(.. "augroup " name)
       "autocmd!"
       (table.concat [...] "\n")
       "augroup END"]
      "\n")
    false))

(fn au [events pattern mod fun]
  (let
    [events
     (match (type events)
       :table (table.concat events ",")
       :string events)

     body
     (..  "lua require('" mod "')." fun "(vim.deepcopy(vim.v.event))")]

    (table.concat ["exe" "\"" "autocmd" events pattern body "\""] " ")))

; (augroup
;   :LuaFtdetect
;   (au [:BufRead] "*" :dirlocal :ftdetect))

dirlocal
