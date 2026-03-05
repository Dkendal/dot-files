source ~/.config/nushell/config.nu

use functions/jira.nu

alias fg = job unfreeze
alias p = polars

$env.config.keybindings ++= [
  {
    name: get_fzf_file
    modifier: CONTROL
    keycode: Char_f
    mode: [emacs, vi_normal, vi_insert]
    event: {
      send: executehostcommand,
      cmd: `commandline edit --insert (fzf | decode utf-8 | str trim)`
    }
  }
]
