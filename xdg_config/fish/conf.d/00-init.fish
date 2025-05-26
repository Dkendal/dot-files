# set -x GPG_TTY (tty)

if test -d ~/.local/bin
  fish_add_path ~/.local/bin
end

if test -d /Applications/kitty.app/Contents/MacOS/
  fish_add_path /Applications/kitty.app/Contents/MacOS/
end

if test -d /opt/homebrew/bin
  fish_add_path /opt/homebrew/bin
end

if test -d ~/.cargo/bin/
  fish_add_path ~/.cargo/bin/
end

function fish_safe_bass_source -a file
  if test -r $file
    bass source $file
  end
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
