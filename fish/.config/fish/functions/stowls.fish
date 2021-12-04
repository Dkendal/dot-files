function stowls \
    --description "List files owned by stow"
    git -C $STOW_DIR ls-files --exclude-standard --others --cached
end
