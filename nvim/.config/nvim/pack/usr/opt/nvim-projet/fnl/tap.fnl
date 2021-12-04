(local lume (require :lume))
(local tap {})
(local setup [])
(local tests [])
(var count 0)

(fn tap.setup [callback]
  (table.insert setup callback))

(fn tap.test [name callback]
  (set count (+ count 1))
  (local cnt count)

  (fn test []
    (-> (match [(pcall callback)]
          [false err]
          (.. "not ok " cnt " - " name "\n# " (-> err (lume.split "\n") (table.concat "
# ")))
          [true] (.. "ok " cnt " - " name))
        (print)))

  (table.insert tests test))

(fn tap.start []
  (print (.. :1.. count))
  (lume.map setup (fn [f]
                    (f)))
  (lume.map tests (fn [f]
                    (f))))

tap

