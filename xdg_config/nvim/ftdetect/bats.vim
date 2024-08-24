augroup filetypedetect_bats
  au!
  au BufRead,BufNewFile *.bats set filetype=bash | filetype detect
augroup END
