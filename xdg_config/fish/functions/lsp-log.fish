function lsp-log --wraps=tail\ -f\ /home/dylan/.cache/nvim/lsp.log\ \|\ colout\ \'.\*ERROR.\*\'\ red --description alias\ lsp-log\ tail\ -f\ /home/dylan/.cache/nvim/lsp.log\ \|\ colout\ \'.\*ERROR.\*\'\ red
  tail -f /home/dylan/.cache/nvim/lsp.log | colout '.*ERROR.*' red $argv; 
end
