augroup filetypedetect_ejson
  au!
  au BufRead,BufNewFile *.ejson set filetype=json | filetype detect
augroup END
