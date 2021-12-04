(set vim.o.swapfile false)
(set vim.o.backup false)
(set vim.o.shada "")
(set vim.o.cmdheight 99)

(local inspect vim.inspect)
(local cmd vim.cmd)
(local v vim.fn)

(local yaml (require :yaml))
(local tap (require :tap))
(local lume (require :lume))
(local projet (require :projet))

(var count 0)

(fn assert-equal [msg expected actual]
  (set count (+ count 1))
  (local cnt count)
  (print (.. "# " msg))

  (fn f []
    (assert (= expected actual) {: expected : actual}))

  (match [(pcall f)]
    [true] (do
             (print (.. "ok " count " " msg))
             print
             "\n")
    [false err] (do
                  (print (.. "not ok " count " " msg))
                  (print (-> [err] (yaml.dump)))))
  (print "\n"))

(projet.init)

(cmd "e fnl/projet.fnl")
(cmd :ASpec)
(assert-equal "changes to spec buffer fom src" :spec/projet_spec.fnl
              (v.bufname))

(cmd :ASrc)
(assert-equal "changes to src buffer from spec" :fnl/projet.fnl (v.bufname))

; (cmd "e ./fnl/projet/init.fnl")
; (cmd :ASpec)
; (assert-equal (v.bufname) :spec/projet/init_spec.fnl)

; (print "test:done")

(print (.. :1.. count))

