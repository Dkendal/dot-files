set -x BAT_THEME gruvbox-dark
set -x GOPATH ~/src
set -x NNN_USE_EDITOR 1
set -x pure_color_mute yellow
set -x DENO_INSTALL ~/.deno

bass source /etc/profile.d/nix.sh

fish_add_path ~/.local/bin
fish_add_path ~/bin
fish_add_path $GOPATH/bin
fish_add_path ~/code/github.com/apenwarr/redo/bin
fish_add_path ~/.fzf/bin
fish_add_path ~/argbash/argbash-2.9.0/bin
fish_add_path ~/.dprint/bin
fish_add_path $DENO_INSTALL/bin
fish_add_path ~/.fly/bin/flyctl

set -x GPG_TTY (tty)

function fish_user_init_abbrs
  echo -n Setting abbreviations...

  abbr -a -- cat bat
  abbr -a -- ci 'hub ci-status -v'
  abbr -a -- ci 'open (hub ci-status -v | cut -f3)'
  abbr -a -- cio 'open (hub ci-status -v | cut -f3)'
  abbr -a -- ddus 'dev down; and dev up; and dev s'
  abbr -a -- dus 'dev up; and dev s'
  abbr -a -- g git
  abbr -a -- gC 'git commit --verbose --no-verify'
  abbr -a -- ga 'git add'
  abbr -a -- gb 'git branch'
  abbr -a -- gbX 'git branch -D'
  abbr -a -- gbc 'git checkout -b'
  abbr -a -- gbx 'git branch -d'
  abbr -a -- gc 'git commit --verbose'
  abbr -a -- gcF 'git commit --verbose --amend'
  abbr -a -- gcb 'git rev-parse --abbrev-ref HEAD'
  abbr -a -- gcf 'git commit --amend --reuse-message HEAD'
  abbr -a -- gco 'git checkout'
  abbr -a -- gdd 'git difftool --no-symlinks --dir-diff'
  abbr -a -- gff 'git pull --ff-only'
  abbr -a -- gfr 'git pull --rebase'
  abbr -a -- giA 'git add --patch'
  abbr -a -- giR 'git reset --patch'
  abbr -a -- gia 'git add'
  abbr -a -- gid 'git diff --cached'
  abbr -a -- gir 'git reset'
  abbr -a -- glg 'git lg'
  abbr -a -- glg 'git log --graph --oneline --boundary'
  abbr -a -- gmb 'git merge-base origin/master @'
  abbr -a -- gp 'git push'
  abbr -a -- gpf 'git push --force-with-lease'
  abbr -a -- gr 'git rebase'
  abbr -a -- gri 'git rebase -i'
  abbr -a -- gs 'git show'
  # abbr -a -- gs 'git stash --keep-index --include-untracked'
  abbr -a -- gS 'git stash'
  abbr -a -- gsa 'git stash apply'
  abbr -a -- gsp 'git stash pop'
  abbr -a -- gwd 'git diff'
  abbr -a -- gwip 'git add -A; and git commit --no-verify -m wip'
  abbr -a -- gws 'git status --short'
  abbr -a -- kittydiff 'kitty +kitten diff'
  abbr -a -- ls exa
  abbr -a -- sed 'sed -E'
  abbr -a -- td 'tmux attach -d -t'
  abbr -a -- yws 'yarn workspace'
  abbr -a stripansi "sed -E 's/\x1b\[[0-9;]*m//g'"

  echo 'Done'
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

if [ -d ~/.asdf ]
  source ~/.asdf/asdf.fish
  asdf exec direnv hook fish | source;
  alias direnv 'asdf exec direnv'
end

if test -z "$LUA_PATH"
  echo "setting LUA_PATH"
  set -xU LUA_PATH (luarocks path --lr-path)
  echo "setting LUA_CPATH"
  set -xU LUA_CPATH (luarocks path --lr-cpath)
end

if command --query zoxide
  zoxide init fish | source
end

if [ "$TERM" = "xterm-kitty" ]
  kitty + complete setup fish | source
  set -x KITTY_LISTEN_ON unix:@mykitty
end

if [ -n "$INSIDE_EMACS" ]
  function fish_title
  end
  set EDITOR "emacsclient -n"
end

bass source '/snap/google-cloud-sdk/current/path.bash.inc'

source ("/usr/local/bin/starship" init fish --print-full-init | psub)
