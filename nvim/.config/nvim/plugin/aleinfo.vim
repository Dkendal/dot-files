function! aleinfo#open()
    redir => buff
      silent call ale#debugging#Info()
    redir END
    enew
    put=buff
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber
endfunction
