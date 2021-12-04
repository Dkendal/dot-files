(local pl (require :pl))

(fn reload [mod]
  ; (tset package.loaded mod nil)
  ; (tset _G mod nil)
  (require mod))

(describe :get-linkfile ;
          (test "does the thing" ;
                (global vim {}) ;
                (local mod (reload :projet)) ;
                (->> (mod.get-linkfile link [:a :b])
                     (assert.are.equal))))

