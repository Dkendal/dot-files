function update_default_npm_packages --wraps='bat ~/.default-npm-packages | xargs npm install --global' --description 'alias update_default_npm_packages bat ~/.default-npm-packages | xargs npm install --global'
  bat ~/.default-npm-packages | xargs npm install --global $argv; 
end
