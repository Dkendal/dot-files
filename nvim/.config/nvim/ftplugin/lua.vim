nmap <buffer> <leader>feR :call luaeval('reload(_A)', substitute(substitute(substitute(expand('%:p:r'), '.*/lua/', '', ''), '/init', '', ''), '/', '.', 'g'))<cr>
