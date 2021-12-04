fun! FloatingFZF()
  set winblend=5
  let width = float2nr(&columns * 0.8)
  let height = float2nr(&lines * 0.8)
  let opts = {
        \     'relative': 'editor',
        \     'row': (&lines - height) / 2,
        \     'col': (&columns - width) / 2,
        \     'width': width,
        \     'height': height,
        \     'style': 'minimal'
        \ }

  let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)

  call setwinvar(win, '&winhl', 'Normal:Pmenu')

  setlocal
        \ buftype=nofile
        \ nobuflisted
        \ bufhidden=hide
endf

" let g:fzf_layout = { 'window': 'call FloatingFZF()' }
