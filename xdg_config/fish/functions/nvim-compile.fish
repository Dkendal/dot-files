function nvim-compile --wraps='nvim +PackerCompile +q' --description 'alias nvim-compile nvim +PackerCompile +q'
  nvim +PackerCompile +q $argv; 
end
