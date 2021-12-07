-- Force vim to use a specific version of node
-- let $PATH = $HOME.'/.asdf/installs/nodejs/14.15.5/bin:' . $PATH
local ex = vim.api.nvim_command
local fn = vim.fn

local init = {}
_G.init = init

local packer_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(packer_path)) > 0 then
    print("downloading packer.nvim...")
    fn.system({
        'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        packer_path
    })
    print("downloading packer.nvim... done")
end

-- ex 'packadd! packer.nvim'
ex 'packadd! nvim-fennel'

require 'nvim-fennel'
require 'config'
