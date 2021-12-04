(local {: setup} (require :nvim-treesitter.configs))

(local parser-config (: (require :nvim-treesitter.parsers) :get_parser_configs))

(set parser-config.org {:filetype :org
                        :install_info {:url "https://github.com/milisims/tree-sitter-org"
                                       :revision :main}})

(set parser-config.markdown
     {:filetype :markdown
      :install_info {:url "https://github.com/ikatyang/tree-sitter-markdown"
                     :files [:src/parser.c :src/scanner.cc]
                     :branch :master}})

;; fnlfmt: skip
(local textobjects
       {:swap {:enable true
               :swap_next {:<leader>a ":@parameter.inner"}
               :swap_previous {:<leader>A ":@parameter.inner"}}
        :move {:enable true
               :set_jumps true
               :goto_next_start {"]m" ":@function.outer" "]a" ":@parameter.inner"}
               :goto_next_end {"]M" ":@function.outer"}
               :goto_previous_start {"[m" ":@function.outer"
                                     "[a" ":@parameter.inner"}
               :goto_previous_end {"[M" ":@function.outer"}}
        :select {:enable true
                 ;; Automatically jump forward to textobj similar to targets.vim 
                 :lookahead true
                 :keymaps {;; You can use the capture groups defined in textobjects.scm
                           :af ":@function.outer"
                           :if ":@function.inner"
                           :ac ":@class.outer"
                           :ic ":@class.inner"
                           :ia ":@parameter.inner"
                           :aa ":@parameter.outer"}}})

(local query_linter {:enable true
                     :use_virtual_text true
                     :lint_events [:BufWrite :CursorHold]})

(local playground {:enable true
                   :disable {}
                   :updatetime 25
                   :persist_queries false
                   :keybindings {:toggle_query_editor :o
                                 :toggle_hl_groups :i
                                 :toggle_injected_languages :t
                                 :toggle_anonymous_nodes :a
                                 :toggle_language_display :I
                                 :focus_language :f
                                 :unfocus_language :F
                                 :update :R
                                 :goto_node :<cr>
                                 :show_help "?"}})

(local incremental_selection
       {:enable true
        :keymaps {:init_selection (t :<leader>v)
                  :node_incremental :<M-n>
                  :scope_incremental :<M-N>
                  :node_decremental :<M-p>}})

(local refactor
       {:highlight_definitions {:enable true}
        :highlight_current_scope {:enable false}
        :smart_rename {:enable true :keymaps {:smart_rename :<leader>rr}}})

(setup {:ensure_installed {}
        :treeclimber {:enable true}
        : query_linter
        : playground
        : incremental_selection
        :indent {:enable true}
        : refactor
        :highlight {:enable true
                    :disable [:org]
                    :additional_vim_regex_highlighting [:org]
                    :custom_captures {}}
        :rainbow {:enable true :extended_mode true}})

