function iplot
	set -l script "
    set terminal pngcairo enhanced font 'Cascadia Mono,10'
    set autoscale
    set samples 1000
    set output '|kitty +kitten icat --stdin yes'
    set object 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgb\"#fdf6e3\" behind
    $argv
    set output '/dev/null'
	"

	echo $script  | gnuplot
end
