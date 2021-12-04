augroup filetypedetect_json
  au!
  au BufRead,BufNewFile *.json set filetype=json | filetype detect
  au BufRead,BufNewFile tsconfig.json set filetype=jsonc | filetype detect
augroup END
