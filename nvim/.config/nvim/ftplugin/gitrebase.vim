function! s:commitCmd(cmd) abort
  let commit = split(getline('.'), '\W\+')[1]
  exec ":vs"
  exec ":term ".substitute(a:cmd, '%', commit, '')
endfunction

command! -nargs=+ CommitCmd :call s:commitCmd(<q-args>)

nmap <localleader>p :Pick<cr>
nmap <localleader>s :Squash<cr>
nmap <localleader>d :Drop<cr>
nmap <localleader>e :Edit<cr>
nmap <localleader>r :Reword<cr>
nmap <localleader>f :Fixup<cr>
nmap <localleader>c :Cycle<cr>

nn <localleader><tab> :CommitCmd git show %<cr>
nn <localleader><s-tab> :CommitCmd git show --stat %<cr>
