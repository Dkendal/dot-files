(require-macros :macros)

(fn package-json [default]
  (local pkg-json (vim.fn.findfile :package.json ".;"))
  (when pkg-json
    (local pkg (vim.fn.json_decode (vim.fn.readfile pkg-json)))
    (when (-?> pkg (. :scripts) (. :fmt))
      {:exe :yarn :args [:run :fmt] :stdin false})))

(let [formatter (require :formatter)
      whitespace #{:exe :sed :args [:-i "'s/[ \t]*$//'"] :stdin true}
      shfmt #{:exe :shfmt :args [] :stdin true}
      mix #{:exe :mix :args [:format "-"] :stdin true}
      joker #{:exe :joker :args [:--format :--write] :stdin false}
      fnlfmt #{:exe :fnlfmt :args ["-"] :stdin true}
      luaformat #{:exe :lua-format :args [] :stdin true}
      prettier #{:exe :prettier :args [:--write] :stdin false}
      import-sort #{:exe :import-sort :args [:--write] :stdin false}
      jsbeautify #{:exe :npx
                   :args [:js-beautify
                          :--end-with-newline
                          :--type
                          :html
                          :--file
                          "-"]
                   :stdin true}
      jq #{:exe :npx :args [:jq "'.'"] :stdin true}
      rufo #{:exe :rufo :args [] :stdin false}
      buildifier #{:exe :buildifier :args [] :stdin false}
      pg_format #{:exe :pg_format :args [] :stdin true}
      dprint #{:exe :dprint
               :args [:fmt :--config "~/.dprintrc.json"]
               :stdin false}
      js [prettier]]
  (formatter.setup {:logging true
                    :filetype {:* [whitespace]
                               :sql [pg_format]
                               :sh [shfmt]
                               :bash [shfmt]
                               :ruby [rufo]
                               :elixir [mix]
                               :eelixir [jsbeautify]
                               :bzl [buildifier]
                               :fennel [fnlfmt]
                               :lua [luaformat]
                               :json [#(or (package-json) (jq))]
                               :jsonc [#(or (package-json) (jq))]
                               :javascript [#(or (package-json) (prettier))]
                               :yaml [prettier]
                               :markdown [#(or (package-json) (prettier))]
                               :html [prettier]
                               :typescript [#(or (package-json) (prettier))]
                               :javascriptreact [#(or (package-json) (prettier))]
                               :typescriptreact [#(or (package-json) (prettier))]}}))

(map :n :<leader>ef ":Format<CR>")

