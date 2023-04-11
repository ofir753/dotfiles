NVLOG = vim.env.NVLOG

-- TODO: nvlog
-- TODO: fire-nvim

-- Remape space as leader key
-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


require('globals')

local rdir = require('utils.require_dir')
rdir.setup()

rdir.require('config')
rdir.require('config/keymaps')

-- Lazy load config files
vim.api.nvim_create_autocmd('User', {
	pattern = 'LazyVimStarted',
	callback = function()
		rdir.recursive_require('config/lazy')

		-- TODO: remove vim from my config :)
		vim.cmd([[
source $HOME/.config/nvim/vim/file_util.vim
]])
	end,
})

require('lazy_config')
