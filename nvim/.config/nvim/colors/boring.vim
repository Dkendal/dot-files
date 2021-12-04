hi clear

if exists('syntax_on')
  syntax reset
endif

" background  #000000
" foreground  #CCCCCC
" invisibles  #6A6A6A
" comments    #6C6C6C
" cursorLine  #292929
" selection   #515151
" variables   #787878
" operator    #AAAAAA
" function    #EFEFEF
" class       #DDDDDD
" prime       #F5C828
" secondary   #FFD951
" yellow      #E2BF40

if &background ==# 'dark'
  let s:background = "#000000"
  let s:foreground = "#CCCCCC"
  let s:invisibles = "#6A6A6A"
  let s:comments = "#6C6C6C"
  let s:cursorLine = "#292929"
  let s:selection = "#515151"
  let s:variables = "#787878"
  let s:operator = "#AAAAAA"
  let s:function = "#EFEFEF"
  let s:class = "#DDDDDD"
  let s:primary = "#F5C828"
  let s:secondary = "#FFD951"
  let s:tertiary = "#E2BF40"
else
  let s:background = "#FFFFFF"
  let s:foreground = "#000000"
  let s:invisibles = "#6A6A6A"
  let s:comments = "#6C6C6C"
  let s:cursorLine = "#292929"
  let s:selection = "#EEEEEE"
  let s:variables = "#555555"
  let s:operator = "#AAAAAA"
  let s:function = "#555555"
  let s:class = "#555555"
  let s:primary = "#4c3a00"
  let s:secondary = "#00324c"
  let s:tertiary = "#4c003b"
endif

fun! <sid>Hi(group, opts)
  let l:cmd = "hi " . a:group

  for item in items(a:opts)
    let l:cmd = l:cmd . " " . join(item, "=")
  endfor

  execute(l:cmd)
endfun

call <SID>Hi('Boolean', {'guifg': s:primary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('Character', {'guifg': s:primary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('ColorColumn', {'guifg': s:foreground, 'guibg': s:cursorLine, 'gui': 'bold', 'ctermfg': '250', 'ctermbg': '008'})
call <SID>Hi('Comment', {'guifg': s:comments, 'guibg': 'NONE', 'gui': 'italic', 'ctermfg': '243'})
call <SID>Hi('Conditional', {'guifg': s:tertiary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('Constant', {'guifg': s:primary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('Cursor', {'guifg': s:invisibles, 'guibg': s:function, 'gui': 'NONE', 'ctermfg': '008', 'ctermbg': '255'})
call <SID>Hi('CursorColumn', {'guifg': 'NONE', 'guibg': s:cursorLine, 'gui': 'NONE', 'ctermfg': 'NONE', 'ctermbg': '008', 'cterm': 'NONE'})
call <SID>Hi('CursorIM', {'guifg': s:background, 'guibg': s:foreground, 'gui': 'NONE', 'ctermfg': '008', 'ctermbg': '255'})
call <SID>Hi('CursorLine', {'guifg': 'NONE', 'guibg': s:cursorLine, 'gui': 'NONE', 'ctermfg': 'NONE', 'ctermbg': '008', 'cterm': 'NONE'})
call <SID>Hi('CursorLineNr', {'guifg': s:class, 'guibg': s:background, 'gui': 'bold', 'ctermfg': '255', 'ctermbg': 'NONE', 'cterm': 'bold'})
call <SID>Hi('DiffAdd', {'guifg': 'NONE', 'guibg': '#103010', 'gui': 'bold', 'ctermfg': '002'})
call <SID>Hi('DiffChange', {'guifg': 'NONE', 'guibg': '#504010', 'gui': 'bold', 'ctermfg': '226'})
call <SID>Hi('DiffDelete', {'guifg': '#501010', 'guibg': '#501010', 'gui': 'bold', 'ctermfg': '009'})
call <SID>Hi('DiffText', {'guifg': 'NONE', 'guibg': '#333333', 'gui': 'bold', 'ctermfg': '250'})
call <SID>Hi('Directory', {'guifg': s:primary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('Error', {'guifg': '#FF3D23', 'guibg': 'NONE', 'gui': 'bold', 'ctermfg': '009', 'ctermbg': 'NONE'})
call <SID>Hi('ErrorMsg', {'guifg': '#FF3D23', 'guibg': 'NONE', 'gui': 'bold', 'ctermfg': '009', 'ctermbg': 'NONE', 'cterm': 'bold'})
call <SID>Hi('Exception', {'guifg': s:tertiary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('FoldColumn', {'guifg': s:background, 'guibg': s:primary, 'gui': 'NONE', 'ctermfg': '235', 'ctermbg': '226'})
call <SID>Hi('Folded', {'guifg': s:background, 'guibg': s:primary, 'gui': 'NONE', 'ctermfg': '235', 'ctermbg': '226'})
call <SID>Hi('Function', {'guifg': s:function, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '255'})
call <SID>Hi('GitGutterAddDefault', {'guifg': '#87BF19', 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '002'})
call <SID>Hi('GitGutterChangeDefault', {'guifg': s:primary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('GitGutterDeleteDefault', {'guifg': '#FF3D23', 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '009'})
call <SID>Hi('Identifier', {'guifg': s:variables, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '246'})
call <SID>Hi('IncSearch', {'guifg': s:background, 'guibg': s:tertiary, 'gui': 'NONE', 'ctermfg': '255', 'ctermbg': '226'})
call <SID>Hi('Keyword', {'guifg': s:tertiary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('Label', {'guifg': s:tertiary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('LineNr', {'guifg': s:invisibles, 'guibg': s:background, 'gui': 'NONE', 'ctermfg': '245', 'ctermbg': 'NONE'})
call <SID>Hi('MatchParen', {'guifg': s:background, 'guibg': s:primary, 'gui': 'NONE', 'ctermfg': '235', 'ctermbg': '226'})
call <SID>Hi('MoreMsg', {'guifg': '#87BF19', 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '002', 'ctermbg': 'NONE'})
call <SID>Hi('NonText', {'guifg': s:invisibles, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '008'})
call <SID>Hi('Normal', {'guifg': s:foreground, 'guibg': s:background, 'gui': 'NONE', 'ctermfg': '250'})
call <SID>Hi('Number', {'guifg': s:primary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('Operator', {'guifg': s:operator, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '246'})
call <SID>Hi('OverLength', {'guifg': 'NONE', 'guibg': '#20272F', 'gui': 'NONE', 'ctermfg': 'NONE', 'ctermbg': '018'})
call <SID>Hi('OverLength', {'guifg': 'NONE', 'guibg': '#4B4B19', 'gui': 'NONE', 'ctermfg': 'NONE', 'ctermbg': '058'})
call <SID>Hi('Pmenu', {'guifg': s:function, 'guibg': s:background, 'gui': 'NONE', 'ctermfg': '255', 'ctermbg': '000'})
call <SID>Hi('PmenuSel', {'guifg': s:background, 'guibg': s:primary, 'gui': 'NONE', 'ctermfg': '235', 'ctermbg': '226'})
call <SID>Hi('PmenuThumb', {'guifg': s:background, 'guibg': s:primary, 'gui': 'NONE', 'ctermfg': '235', 'ctermbg': '226'})
call <SID>Hi('PreProc', {'guifg': s:variables, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '246'})
call <SID>Hi('Question', {'guifg': '#64B2DB', 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '039', 'ctermbg': 'NONE'})
call <SID>Hi('Repeat', {'guifg': s:tertiary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('Search', {'guifg': s:background, 'guibg': s:primary, 'gui': 'NONE', 'ctermfg': '235', 'ctermbg': '226'})
call <SID>Hi('SignColumn', {'guifg': s:function, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '255', 'ctermbg': 'NONE'})
call <SID>Hi('Special', {'guifg': s:function, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '255'})
call <SID>Hi('SpecialKey', {'guifg': s:primary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('SpellBad', {'guisp': '#FF3D23', 'guibg': 'NONE', 'gui': 'undercurl', 'ctermfg': '255', 'ctermbg': '009', 'cterm': 'underline'})
call <SID>Hi('SpellCap', {'guisp': '#87BF19', 'guibg': 'NONE', 'gui': 'undercurl', 'ctermfg': '255', 'ctermbg': '002', 'cterm': 'underline'})
call <SID>Hi('SpellLocal', {'guisp': s:primary, 'guibg': 'NONE', 'gui': 'undercurl', 'ctermfg': '255', 'ctermbg': '226', 'cterm': 'underline'})
call <SID>Hi('SpellRare', {'guisp': s:primary, 'guibg': 'NONE', 'gui': 'undercurl', 'ctermfg': '255', 'ctermbg': '226', 'cterm': 'underline'})
call <SID>Hi('Statement', {'guifg': s:foreground, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '250'})
call <SID>Hi('StatusLine', {'guifg': s:foreground, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '000', 'ctermbg': '250'})
call <SID>Hi('StatusLineNC', {'guifg': s:comments, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '000', 'ctermbg': '246'})
call <SID>Hi('String', {'guifg': s:secondary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('TabLine', {'guifg': s:foreground, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '250', 'ctermbg': 'NONE', 'cterm': 'NONE'})
call <SID>Hi('TabLineFill', {'guifg': s:foreground, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '250', 'ctermbg': 'NONE', 'cterm': 'NONE'})
call <SID>Hi('Title', {'guifg': s:foreground, 'guibg': 'NONE', 'gui': 'bold', 'ctermfg': '250'})
call <SID>Hi('Todo', {'guifg': s:primary, 'guibg': 'NONE', 'gui': 'bold', 'ctermfg': '226', 'ctermbg': 'NONE'})
call <SID>Hi('Type', {'guifg': s:tertiary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226'})
call <SID>Hi('Underlined', {'guifg': s:foreground, 'guibg': 'NONE', 'gui': 'underline', 'ctermfg': '250'})
call <SID>Hi('VertSplit', {'guifg': s:comments, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '000', 'ctermbg': '246'})
call <SID>Hi('Visual', {'guifg': s:function, 'guibg': s:selection, 'gui': 'NONE', 'ctermfg': '255', 'ctermbg': '008'})
call <SID>Hi('VisualNOS', {'guifg': s:function, 'guibg': s:selection, 'gui': 'NONE', 'ctermfg': '255', 'ctermbg': '008'})
call <SID>Hi('WarningMsg', {'guifg': s:primary, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '226', 'ctermbg': 'NONE'})
call <SID>Hi('WildMenu', {'guifg': s:background, 'guibg': s:primary, 'gui': 'NONE', 'ctermfg': '235', 'ctermbg': '226'})
call <SID>Hi('helpHyperTextJump', {'guifg': s:primary, 'guibg': 'NONE', 'gui': 'underline', 'ctermfg': '226', 'ctermbg': 'NONE', 'cterm': 'underline'})
call <SID>Hi('helpNote', {'guifg': s:foreground, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '250'})
call <SID>Hi('helpSpecial', {'guifg': s:foreground, 'guibg': 'NONE', 'gui': 'NONE', 'ctermfg': '250'})

hi link                       markdownLinkText            PreProc
hi link                       markdownHeadingDelimiter    Number
hi link                       markdownHeader              Number
hi link                       markdownInlineCode          PreProc
hi link                       markdownFencedCodeBlock     PreProc
hi link                       markdownCodeBlock           PreProc
highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
highlight link multiple_cursors_visual Visual
