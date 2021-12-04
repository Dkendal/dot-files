function! aleinfo#open() abort
  redir => buff
    silent call ale#debugging#Info()
  redir END
  new
  put=buff
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber ft=vim
endfunction
