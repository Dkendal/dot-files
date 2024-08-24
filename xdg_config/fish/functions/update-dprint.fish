# Defined in - @ line 1
function update-dprint --wraps='curl -fsSL https://dprint.dev/install.sh | sh' --description 'alias update-dprint curl -fsSL https://dprint.dev/install.sh | sh'
  curl -fsSL https://dprint.dev/install.sh | sh $argv;
end
