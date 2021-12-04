if exists('g:loaded_kitty') && g:loaded_kitty
  finish
endif

let g:loaded_kitty = 1
let g:kitty_window_title = 'vim-test-output'
let s:tail_until_path = globpath(&runtimepath, 'tools/vim-kitty-tail-until.awk')

function! s:test_configuration() abort
  try
    let cmd = 'kitty @ ls'
    call json_decode(system(cmd))
  catch //
    " TODO fact checkthis
    let msg =  '' .
          \ 'Kitty might not be properly configured. Make sure that the terminal was' .
          \ ' started with --remote control support. Try running `kitty @ ls`, if it' .
          \ ' returns JSON then you should be good to go!'

    echoerr msg
  endtry
endfunction

function! s:get_text_cmd(search_text) abort
  let cmd = [printf('kitty @ get-text --extent=screen --match title:%s', g:kitty_window_title)]

  if a:search_text != v:false
    let cmd += [
          \   'tac',
          \   'awk -v search_text=' . shellescape(a:search_text) . ' -f' . s:tail_until_path,
          \   'tac'
          \ ]
  endif

  return cmd
endfunction

function! s:run(cmd) abort
  return systemlist(join(a:cmd, '|'))
endfunction

function! kitty#get_text(search_text) abort
  return systemlist(s:get_text_cmd(a:search_text))
endfunction

function! kitty#send_text(text) abort
  let cmd = printf('kitty @ send-text --stdin --match title:%s', g:kitty_window_title)
  let out = system(cmd, a:text)
  if v:shell_error
    echoerr printf("Can't find a target window, please run `kitty @ set-window-title %s` where you want to send text.", g:kitty_window_title)
  endif
  return out
endfunction

function! kitty#setqflist(opts) abort
  let search_text = get(a:opts, 'until', v:false)
  let pipe = get(a:opts, 'pipe', v:false)
  let cmd = s:get_text_cmd(search_text)

  if type(pipe) == v:t_list
    let cmd += pipe
  endif

  let lines = s:run(cmd)
  let t = 'Kitty text'
  let c = {'cmd': 'kitty buffer text'}
  let opts = {'title': t, 'context': c, 'lines': lines}
  call setqflist([], ' ', opts)
  doautocmd QuickFixCmdPost
endfunction

comm! -bang -nargs=? KittySetQflist :call kitty#setqflist(<f-args>)

nnoremap <Plug>(kitty-send-buff) :call kitty#send_text(getline(1, '$'))
nnoremap <Plug>(kitty-send-line) :call kitty#send_text(getline('.'))
vnoremap <Plug>(kitty-send-visual) <c-u>:call kitty#send_text(getline("'<", "'>"))
vnoremap <Plug>(kitty-send-selection) "ry :call kitty#send_text(@r)<cr>
