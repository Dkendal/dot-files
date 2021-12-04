augroup filetypedetect_do
  au!
  au BufRead,BufNewFile *.do set filetype=sh | filetype detect
augroup END
