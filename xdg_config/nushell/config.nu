source ~/.config/nushell/config.nu

plugin add nu_plugin_polars
plugin use polars

use functions/jira.nu

alias fg = job unfreeze
alias claude = ~/.claude/local/claude
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
