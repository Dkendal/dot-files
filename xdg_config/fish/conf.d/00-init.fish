set -x GPG_TTY (tty)

if test -d /Applications/kitty.app/Contents/MacOS/
  fish_add_path /Applications/kitty.app/Contents/MacOS/
end

function fish_safe_bass_source -a file
  if test -r $file
    bass source $file
  end
end

function fish_set_user_abbr
  # Abbreviations
  abbr -a -- ci 'hub ci-status -v'
  abbr -a -- ci 'open (hub ci-status -v | cut -f3)'
  abbr -a -- cio 'open (hub ci-status -v | cut -f3)'
  abbr -a -- dus 'dev up; and dev s'

  abbr -a -- g git
  abbr -a -- gC 'git commit --verbose --no-verify'
  abbr -a -- gS 'git stash push'
  abbr -a -- ga 'git add'
  abbr -a -- gb 'git-switch-choose'
  abbr -a -- gbX 'git branch -D'
  abbr -a -- gbc 'git switch -c'
  abbr -a -- gbx 'git branch -d'
  abbr -a -- gc 'git commit --verbose'
  abbr -a -- gcF 'git commit --verbose --amend'
  abbr -a -- gcb 'git rev-parse --abbrev-ref HEAD'
  abbr -a -- gcf 'git commit --amend --reuse-message HEAD'
  abbr -a -- gco 'git checkout'
  abbr -a -- gdd 'git difftool --no-symlinks --dir-diff'
  abbr -a -- gff 'git pull --ff-only'
  abbr -a -- gfr 'git pull --rebase --autostash'
  abbr -a -- giA 'git add --patch'
  abbr -a -- giR 'git reset --patch'
  abbr -a -- gia 'git add'
  abbr -a -- gid 'git diff --cached'
  abbr -a -- gir 'git reset'
  abbr -a -- glg 'git log --graph --oneline --boundary'
  abbr -a -- gmb 'git merge-base origin/master @'
  abbr -a -- gp 'git push'
  abbr -a -- gpf 'git push --force-with-lease'
  abbr -a -- gr 'git rebase'
  abbr -a -- gri 'git rebase -i'
  abbr -a -- gs 'git show'
  abbr -a -- gsa 'git stash apply'
  abbr -a -- gwd 'git diff'
  abbr -a -- gwip 'git add -A; and git commit --no-verify -m wip'
  abbr -a -- gws 'git status --short'

  abbr -a -- kittydiff 'kitty +kitten diff'
  abbr -a -- ls eza
  abbr -a -- mt 'mix test'
  abbr -a -- mtf 'mix test --failed'
  abbr -a -- mf 'mix-failed'
  abbr -a -- mts 'mix test --stale'
  abbr -a -- sed 'sed -E'
  abbr -a -- td 'tmux attach -d -t'
  abbr -a -- yws 'yarn workspace'
  abbr -a n "nvim --listen ~/.cache/nvim/server.pipe"
  abbr -a nr "nvim --server ~/.cache/nvim/server.pipe --remote"
  abbr -a stripansi "sed -E 's/\x1b\[[0-9;]*m//g'"
end

function fish_user_key_bindings
  # Execute this once per mode that emacs bindings should be used in
  fish_default_key_bindings -M insert
  # Without an argument, fish_vi_key_bindings will default to
  # resetting all bindings.
  # The argument specifies the initial mode (insert, "default" or visual).
  fish_vi_key_bindings insert

  bind \co edit_command_buffer
  bind -M insert \co edit_command_buffer
  bind -M normal \co edit_command_buffer
end

if type -fq mise
  mise activate fish | source
end

if type -fq starship
  starship init fish | source
end

# Lazy load zoxide
function z
  if type -fq zoxide
    zoxide init fish | source
  end
  z $argv
end

if type -fq direnv
  direnv hook fish | source
end

if type -fq kitty
  kitty + complete setup fish | source
end

if set -q KITTY_INSTALLATION_DIR
  # Manual kitty shell integration
  set --global KITTY_SHELL_INTEGRATION enabled
  source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
  set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
end

if [ -n "$INSIDE_EMACS" ]
  function fish_title
  end
  set EDITOR "emacsclient -n"
end

fish_safe_bass_source $HOME/.local/share/google-cloud-sdk/path.bash.inc
fish_safe_bass_source $HOME/.ghcup/env

fzf_key_bindings
fish_set_user_abbr
