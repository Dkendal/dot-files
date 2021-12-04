(local helpers {})

(fn helpers.describe [str ...]
   `(describe ,str (fn [] ,...)))

(fn helpers.it [str ...]
   `(test ,str (fn [] ,...)))

helpers
