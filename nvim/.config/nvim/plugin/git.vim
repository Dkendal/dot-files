function GitCopyRangeAsMarkdown(start, end) abort
  :GBrowse!
  let @* .= "\n"
  let @* .= "```" . &filetype . "\n"
  let @* .= join(nvim_buf_get_lines(0, a:start - 1, a:end, v:false), "\n") . "\n"
  let @* .= "```\n"
endfunction

command -range GitCopyRangeAsMarkdown :call GitCopyRangeAsMarkdown(<line1>, <line2>)

