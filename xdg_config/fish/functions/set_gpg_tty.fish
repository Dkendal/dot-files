# Defined in - @ line 1
function set_gpg_tty --wraps='set -x GPG_TTY (tty)' --description 'alias set_gpg_tty set -x GPG_TTY (tty)'
  set -x GPG_TTY (tty) $argv;
end
