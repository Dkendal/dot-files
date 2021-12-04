let g:quickfix_signs_enabled = v:true

lua package.loaded['quickfix_signs'] = nil

sign define QfSignError texthl=Error text=>
sign define QfSignWarning texthl=WarningMsg text=!
sign define QfSignInfo text=>-

function! QuickfixPlaceSigns() abort
  let list = getqflist()
  let offset = 99000
  let priority = 100
  let group = 'quickfix_signs'

  call sign_unplace('*', {'group': group})

  let id = offset

  let list = filter(list, 'v:val.valid && v:val.bufnr != 0')

  for item in list
    let name = 'QfSignInfo'

    if item.type ==# 'W'
      let name = 'QfSignWarning'
    endif

    if item.type ==# 'E'
      let name = 'QfSignError'
    endif

    let opts = {'lnum' : item.lnum, 'priority' : priority}

    call sign_place(id, group, name, bufname(item.bufnr),  opts)

    let id += 1
  endfor
endfunction

" command! QuickfixPlaceSigns :call QuickfixPlaceSigns()

" augroup quickfix_signs
"   au!
"   au QuickFixCmdPost * :call QuickfixPlaceSigns()
"   au QuickFixCmdPost * :call luaeval("require'quickfix_signs'.quickfixpost(_A)", bufnr())
"   au BufEnter *  call luaeval("require'quickfix_signs'.bufenter(_A)", bufnr())
" augroup END
