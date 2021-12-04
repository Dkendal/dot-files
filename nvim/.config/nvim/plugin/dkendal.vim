func! s:rgi(with_preview)
  let search_term = 'rg --column --line-number --no-heading --color=always --smart-case -- {q} || true'

  let options = { 'options': [
        \   '--bind', 'ctrl-c:abort',
        \   '--bind', printf("change:reload:%s", l:search_term),
        \   '--ansi',
        \   '--phony',
        \   '--prompt', 'Rg> ',
        \   '--preview-window', a:with_preview ? 'up:60%'
        \                                      : 'right:50%:hidden'
        \ ] }

  call fzf#vim#grep('printf ""', 1, fzf#vim#with_preview(options), a:with_preview)
endfunc

comm! -bang Rgi :call s:rgi(<bang>0)

func! s:rg(args, with_preview)
  let search_term = printf(
        \ 'rg --column --line-number --no-heading --color=always --smart-case %s',
        \ a:args)

  let spec = { 'options': [
        \   '--bind', 'ctrl-c:abort',
        \   '--preview-window', a:with_preview ? 'up:60%'
        \                                      : 'right:50%:hidden'
        \ ] }

  call fzf#vim#grep(search_term, 1, fzf#vim#with_preview(spec), a:with_preview)
endfunc

fun! s:rgCurrentLine(fullscreen) abort
  let query = shellescape(trim(getline('.'), ' '))
  let command = printf("%S --fixed-strings", query, 1)
  call s:rg(command, a:fullscreen)
endfun

" Copy all matches from the previous search result into register 0
func! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunc
command! -register CopyMatches call CopyMatches(<q-reg>)

function! s:project_sink(path) abort
  if isdirectory(a:path)
    execute 'tcd' a:path
    execute 'e' a:path
    echo('tabpage dir changed to ' . a:path)
  else
    execute 'e' a:path
  endif
endfunction

com! Projects :call fzf#run(fzf#wrap('Projects',
      \ {'sink': funcref('s:project_sink'), 'source': g:dkendal_projects}))

comm! -bang -nargs=* Rg :call s:rg(<q-args>, <bang>0)

comm! -bang RgCurrentLine :call s:rg(printf("%S --fixed-strings", shellescape(trim(getline('.'), ' '), 1)), <bang>0)

comm! -bang -nargs=* Fd
      \ :call fzf#run(fzf#wrap({
      \   'source': printf('fd %s', <q-args>),
      \   'options': '--ansi',
      \ }))

comm! LayoutTall :windo wincmd L<CR>
comm! LayoutWide :windo wincmd J<CR>


" Display projectionist alternates
function! s:alternates() abort
  let alternates = projectionist#query_file('alternate', {})
  let source = []
  for path in alternates
    let localpath = fnamemodify(path, ':~:.')
    call add(source, localpath)
  endfor
  let options = {}
  let options['source'] = source
  let options['options'] = '--ansi --preview "cat {}"'
  call fzf#run(fzf#wrap('Alternates', options))
endfunction

comm! Alternates :call s:alternates()

function s:log(...) abort
  call writefile(a:000, '/tmp/vim.log', 'a')
endfunction

function s:inspect(...) abort
  call call('s:log', map(copy(a:000), { _, x -> scriptease#dump(x) }))
endfunction

function s:clist_sink(arg) abort
  let [path; _rest] = split(a:arg, " ")
  execute "e " . path
endfunction

function s:clist() abort
  let source = getqflist()
  let source = filter(source, { _, x -> x.valid == v:true })
  call reverse(source)

  " let server = serverstart()

  let out = []
  let path = ''
  for item in source
    if item.bufnr > 0
      let path = bufname(item.bufnr)

      if !filereadable(path)
        let matches = split(globpath('./,apps/*', path))

        if len(matches) > 0
          let path = matches[0]
        endif
      endif

      let path = simplify(path) . ':' . item.lnum
    endif

    let reset = "\e[0;0m"
    let yellow = "\e[0;33m"
    let green = "\e[0;32m"
    let red = "\e[0;49;31m"
    let gray = "\e[0;49;90m"

    let type = item.type

    if type ==# "W"
      let type = l:yellow . item.type . l:reset
    endif

    if type ==# "E"
      let type = l:red . item.type . l:reset
    endif

    let module = l:green . item.module . l:reset
    let text = l:gray . item.text . l:reset

    call add(out, printf("%s [%s] %s %s", path, type, module, text))
  endfor
  let source = out
  call reverse(source)

  let preview = split(globpath(&rtp, "bin/preview.sh"))[0]
  let preview = printf("printf {} | cut -d ' ' -f 1 | xargs %s", preview)
  let options = printf('--ansi --layout=reverse-list --preview "%s"', preview)

  call fzf#run(fzf#wrap({
        \   'source': source,
        \   'sink': funcref('s:clist_sink'),
        \   'options': options,
        \ }))
endfunction

command! VimReloadEnable :autocmd BufWritePost <buffer> Runtime
command! VimReloadDisable :autocmd! BufWritePost <buffer>

command! -nargs=* Inspect :call s:inspect(<args>)
command! -nargs=* Log :call s:log(<args>)

command StartServer :call startserver('/tmp/nvimsocket')

command! -nargs=1 Box :call nvim_put(systemlist(printf('echo %s | boxes -d shell -ac -s 79', <q-args>)), 'l', v:true, v:true)
