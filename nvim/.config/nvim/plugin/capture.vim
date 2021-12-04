function! s:split(expr) abort
  let lines = split(execute(a:expr, 'silent'), "[\n\r]")
  let name = printf('capture://%s', a:expr)

  if bufexists(name) == v:true
    execute 'bwipeout' bufnr(name)
  end

  execute 'botright' 'new' name

  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal filetype=vim

  call append(line('$'), lines)
endfunction

function! s:fzf(expr) abort
  let lines = split(execute(a:expr, 'silent'), "[\n\r]")

  return fzf#run({
      \  'source': lines,
      \  'options': '--tiebreak begin --ansi --header-lines 1'
      \})
endfunction

function s:capture(expr, bang) abort
  if a:bang
    call s:fzf(a:expr)
  else
    call s:split(a:expr)
  endif
endfunction

command! -nargs=1 -bang -complete=command P call s:capture(<q-args>, <bang>0)
