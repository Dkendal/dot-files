# Defined in - @ line 1
function testhere --wraps=kitty\ @\ set-window-title\ --match\ title:vim-test-output\ \'\'\;\ kitty\ @\ set-window-title\ vim-test-output --description alias\ testhere\ kitty\ @\ set-window-title\ --match\ title:vim-test-output\ \'\'\;\ kitty\ @\ set-window-title\ vim-test-output
  kitty @ set-window-title --match title:vim-test-output ''; kitty @ set-window-title vim-test-output $argv;
end
