setl regexpengine=1
setl nocursorline
setl foldmethod=manual

com! FixSorbetSig
      \ :%s/\v<sig>.*\n\zs\n+\ze\s*<def>//e |
      \ :%s/\v(^(\s*)<sig> do\n(\_.{-}\2end)\n)\n(\2def)/\1\4/e

com! SEmptyReturn :'<,'>s/returns()/returns(T.untyped)

com! Arbi :execute printf(":e sorbet/rbi/shims/%S.rbi", expand("%:r"))

cabbr R=> s/:\(\w\+\) =>/\1:/g

fu! s:pathFromSrcToShim(path) abort
  return printf("sorbet/rbi/shims/%S.rbi", a:path)
endfu

" fu! s:pathFromShimToSrc(path) abort
"   return printf("sorbet/rbi/shims/%S.rbi", a:path)
" endfu

com! Arbi :execute printf(":e %S", s:pathFromSrcToShim(expand("%:r")))

com! GenerateShim :call system("sorbet-codegen --write --overwrite -f ".shellescape(expand('%')))
