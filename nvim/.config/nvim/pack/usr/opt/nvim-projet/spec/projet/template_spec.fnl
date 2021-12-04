(require-macros :spec-helper)

(local template (require :projet.template))

(it "empty string is returned as is"
    (->> (template.eval "" []) (assert.are.equals "")))

(it "replaces single binding"
    (->> (template.eval "{}" [:a])
         (assert.are.equals :a)))

(it "replaces multiple bindings"
    (->> (template.eval "{} {}" [:a :b])
         (assert.are.equals "a b")))

(it "replace match with preceding text"
    (->> (template.eval "a{}" [:b])
         (assert.are.equals :ab)))

(it "replace match with proceding text"
    (->> (template.eval "{}b" [:a])
         (assert.are.equals :ab)))

(it "plain text is returned as is"
    (->> (template.eval "foo bar" []) (assert.are.equals "foo bar")))

(it "solo open brace is fine"
    (->> (template.eval "foo { bar" []) (assert.are.equals "foo { bar")))

(it "doesn't touch text outside of the template"
    (->> (template.eval "a{}c" [:b]) (assert.are.equals :abc)))

(it "supports several modifiers with no regard to white space"
    (->> (template.eval "{lower |upper}" [:foo_bar])
         (assert.are.equals :FOO_BAR)))

