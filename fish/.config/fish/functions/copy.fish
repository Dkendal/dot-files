# Defined via `source`
function copy --wraps='xclip --selection clipbox' --description 'alias copy xclip --selection clipbox'
  xclip --selection clipbox $argv; 
end
