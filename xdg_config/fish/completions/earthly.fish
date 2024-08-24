function __fish_earthly_complete
  rg '^(\S+):' -g '**/Earthfile' --hidden --replace '+$1' --with-filename --no-line-number --no-heading . |
    sed -E 's#/Earthfile:##' |
    sed -E "s#\.\+#+#"
end

complete --no-files --command earthly -a "(__fish_earthly_complete)"
