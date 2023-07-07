function idot
  dot -Tpng /dev/stdin $argv | kitty +kitten icat --stdin yes
end
