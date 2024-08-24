function! dkendal#fzf#capture(commandname)
   redir => cout
   silent exec a:commandname
   redir end
   let list = split(cout, "\n")
   return fzf#run({
            \  'source': list,
            \  'options': '--tiebreak begin --ansi --header-lines 1'
            \})
endfunction
