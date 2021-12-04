(local stringx (require :pl.stringx))

(local gh {})

(local history [])

(local api vim.api)
(local ex vim.cmd)
(local v vim.fn)
(local bmap (partial vim.api.nvim_buf_set_keymap 0))

(fn hist-push [s]
  (table.insert history s))

(fn hist-pop []
  (table.remove history))

(fn hist-last []
  (. history (length history)))

(fn gh.hist-back []
  (if (<= (length history) 1)
      (ex ":q")
      (do
        (hist-pop)
        (ex (table.concat [:term :gh (table.unpack (hist-last))] " ")))))

(fn gh.command [...]
  (hist-push [...])
  (ex (table.concat [:term :gh ...] " ")))

(fn gh.next-line []
  (print :next))

(fn fnref [name ?args]
  (local args (string.gsub (vim.inspect (or ?args {})) "%s+" " "))
  (.. ":lua require('gh')['" name "'](table.unpack(" args "))<cr>"))

(fn gh.pr-view []
  (let [pr-num (-> (api.nvim_get_current_line) (string.match "^%s+#(%d+)"))]
    (when pr-num
      (ex (.. "Gh pr view " pr-num)))))

(fn gh.pr-diff []
  (let [pr-num (-> (api.nvim_get_current_line) (string.match "^%s+#(%d+)"))]
    (when pr-num
      (ex (.. "Gh pr diff " pr-num)))))

;; X  debugging                                     .github/workflows/ci.yml  feat-ci-2  push          938222443
(local run-pattern "%s(%d+)$")

;; #1674  Add a small command to introduce a root org and associate to it existi...  mandx:armando/small-cli-to-introduce-root-orgs
(local pr-pattern "^#(%d+)")

(fn gh.run-sub-cmd [cmd]
  (let [id (-> (api.nvim_get_current_line) (string.match run-pattern))]
    (when id
      (ex (.. "Gh " (string.format cmd id))))))

(fn match-current-line [pattern]
  (-> (api.nvim_get_current_line) (string.match pattern)))

(fn gh.line-cmd [pattern cmd]
  (let [id (match-current-line pattern)]
    (print id)
    (when id
      (ex (.. "Gh " (string.format cmd id))))))

(fn gh.keymap []
  (let [tokens ;
        (-> (v.expand "%:t")
            (string.match "%d*:(.*)")
            (stringx.split))
        opts {:nowait true :silent true}]
    ;; Map for all modes
    (bmap :n :q (fnref :hist-back) opts)
    (match tokens
      [:gh :run :list _]
      ;; Actions
      (do
        (local sh #(fnref :line-cmd [run-pattern $1]))
        (bmap :n :<enter> (sh "run view %s") opts))
      [:gh :pr :list]
      (do
        (local sh #(fnref :line-cmd [pr-pattern $1]))
        (bmap :n :<enter> (sh "pr view %s --comments") opts)
        (bmap :n :<enter> (sh "pr view %s --comments") opts)
        (bmap :n :h (sh "pr --help") opts)
        (bmap :n :c (sh "pr checks %s") opts)
        (bmap :n :CC (sh "pr checkout %s") opts)
        (bmap :n :l (sh "pr list") opts)
        (bmap :n :d (sh "pr diff %s") opts)
        (bmap :n :o (sh "pr view %s --web") opts))
      ;: Pr list maps
      [:gh :pr :status _]
      ;: Pr status maps
      (do
        ;; TODO ? open help
        (local sh #(fnref :line-cmd [pr-pattern $1]))
        (bmap :n :<enter> (sh "pr view %s --comments") opts)
        (bmap :n :h (sh "pr --help") opts)
        (bmap :n :c (sh "pr checks %s") opts)
        (bmap :n :CC (sh "pr checkout %s") opts)
        (bmap :n :l (sh "pr list") opts)
        (bmap :n :d (sh "pr diff %s") opts)
        (bmap :n :o (sh "pr view %s --web") opts)
        (bmap :n :n (fnref :next-line) opts)))))

(fn gh.reviews []
  (local api-query
         "is:pr is:open archived:false sort:updated-desc review-requested:Dkendal")
  ; (local jq-query ".items[] | {title, login: .user.login, html_url}")
  (local template
         "{{range .items}}{{.user.login | color \"blue\"}} {{.title | color \"green\"}}{{\"\\n\t\"}}{{ .html_url}}{{\"\\n\"}}{{end}}")
  ; (ex (.. "Gh api -X GET search/issues -f q='" api-query "' --jq '" jq-query "' | jq '.'")))
  (ex (.. "Gh api -X GET search/issues -f q='" api-query "' --template '"
          template "'")))

(fn gh.complete_gh [arg-lead cmd-line cursor-pos] ; (ins [arg-lead cmd-line cursor-pos])
  (local tokens (vim.split (string.sub cmd-line 0 cursor-pos) " +"))
  (-> (match tokens
        [:Gh :gist]
        [:clone :create :delete :edit :list :view]
        [:Gh :issue]
        [:close
         :comment
         :create
         :delete
         :edit
         :list
         :reopen
         :status
         :transfer
         :view]
        [:Gh :pr]
        [:checkout
         :checks
         :close
         :comment
         :create
         :diff
         :edit
         :list
         :merge
         :ready
         :reopen
         :review
         :status
         :view]
        [:Gh :repo]
        [:clone :create :fork :list :view]
        ;; [:Gh :actions] [ ]
        [:Gh :run]
        [:download :list :rerun :view :watch]
        [:Gh :workflow]
        [:disable :enable :list :run :view]
        ;; [:Gh :api] ; [] ; [:Gh :auth] ; [] ; [:Gh :config] ; [] ; [:Gh :help] ; [] ; [:Gh :secret] ; [] ; [:Gh :ssh-key] ; []
        [:Gh]
        [:gist
         :issue
         :pr
         :release
         :repo
         :actions
         :run
         :workflow
         :alias
         :api
         :auth
         :completion
         :config
         :help
         :secret
         :ssh-key])
      (table.concat "\n")))

(fn gh.setup []
  (do
    (ex "
        augroup nvim-gh
        au!
        au TermOpen term://*:gh* lua require'gh'.keymap()
        augroup END
        command! -nargs=* -complete=custom,v:lua.require'gh'.complete_gh Gh :lua require'gh'.command(<f-args>)
        command! -nargs=* GhReviews :lua require'gh'.reviews()
        ")))

gh

