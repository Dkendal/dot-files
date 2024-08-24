# Defined in - @ line 1
function update-kitty --wraps='curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin' --description 'alias update-kitty curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin'
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin $argv;
end
