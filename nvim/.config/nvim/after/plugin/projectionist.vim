if !exists('g:projectionist_transformations')
  let g:projectionist_transformations = {}
endif

function! g:projectionist_transformations.t(input, o)
  return fnamemodify(a:input, ":t")
endfunction

function! g:projectionist_transformations.h(input, o)
  return fnamemodify(a:input, ":h")
endfunction

function! g:projectionist_transformations.r(input, o)
  return fnamemodify(a:input, ":r")
endfunction

function! g:projectionist_transformations.p(input, o)
  return fnamemodify(a:input, ":p")
endfunction

function! g:projectionist_transformations.e(input, o)
  return fnamemodify(a:input, ":e")
endfunction

function! g:projectionist_transformations.gem(input, o)
  return substitute(a:input, '@.*', '', 'g')
endfunction

function! g:projectionist_transformations.rb_class_start(input, o) abort
  return join(luaeval("require('src/projectionist-ext').rb_class_start(_A)", a:input), "\n")
endfunction

function! g:projectionist_transformations.rb_class_end(input, o) abort
  return join(luaeval("require('src/projectionist-ext').rb_class_end(_A)", a:input), "\n")
endfunction

function! g:projectionist_transformations.rb_class_indent(input, o) abort
  return luaeval("require('src/projectionist-ext').rb_class_indent(_A)", a:input)
endfunction
