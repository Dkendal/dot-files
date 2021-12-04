lua require'alefixers'.init()

function! alefixers#sorbet_sig_whitespace(buffer, lines)
  return luaeval('require("src.alefixers").sorbet_sig_format(_A)', a:lines)
endfunction

function! alefixers#importsort(buffer)
  let importsort = fnamemodify(system('which import-sort')[:-2], ':p')
  return {
        \  'command': importsort.' %t',
        \  'read_temporary_file': 0,
        \  'output_stream': 'stdout',
        \}
endfunction

function! alefixers#htmlbeautifier(buffer)
  let executable = fnamemodify(system('which htmlbeautifier')[:-2], ':p')
  return {
        \  'command': executable,
        \  'read_temporary_file': 0,
        \  'output_stream': 'stdout',
        \}
endfunction
