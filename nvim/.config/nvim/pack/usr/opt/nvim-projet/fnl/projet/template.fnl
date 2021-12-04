(local template {})

(local inspect (require :inspect))
(local stringx (require :pl.stringx))
(local seq (require :pl.seq))

(local mods {:upper string.upper :lower string.lower})

(fn apply-mod [name str]
  (match (. mods name)
    nil (error (.. "unknown modifier " name))
    modfn (modfn str)))

(fn template.eval [template-str bindings]
  (local binding (seq.list bindings))
  (string.gsub template-str "{([^{]*)}"
               (fn [str]
                 (local tokens (-> str (stringx.splitv " *| *") (table.pack)))
                 (-> (fn [acc mod-name]
                       (apply-mod mod-name acc))
                     (seq.reduce tokens (binding))))))

template

