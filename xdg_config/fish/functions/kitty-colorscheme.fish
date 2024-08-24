function kitty-colorscheme -a colorscheme
  kitty @ set-colors --all --configured ~/.config/kitty/colors/$colorscheme.conf
end

set -l colorschemes (fd 'conf' ~/.config/kitty/colors | rg $HOME'/.config/kitty/colors/(.*)\.conf' --replace '$1')

complete -c kitty-colorscheme --no-files --require-parameter --arguments "$colorschemes"
