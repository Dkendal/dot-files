function mix-watch
  while true
    fd | entr -d mix test --stale $argv
  end
end
