-----------------------------------------------------------
-- Sessions
-----------------------------------------------------------

-- https://github.com/xolox/vim-session


-- set sessionoptions+=winpos,terminal

if vim.g.started_by_firenvim or not (vim.call('argc', '') == 0) then
	vim.g.session_autosave = 'no'
	vim.g.session_autoload = 'no'
else
	vim.opt.sessionoptions:append({ 'buffers', 'tabpages', 'options' })
	vim.cmd([[
	let g:session_autosave = 'no' " Doesnt save unsaved session for some reason using autocmd instead
	autocmd ExitPre * exec "lua require('dapui').close()" | exec "NvimTreeClose" | exec "DiffviewClose" | exec "redraw!"
	autocmd VimLeavePre * SaveSession
	let g:session_autoload = 'yes'
	let g:session_default_name = getcwd()
	]])
	vim.api.nvim_create_autocmd('SessionLoadPost', {
		pattern = '*',
		callback = function()
			vim.opt.cmdheight = 1
		end
	})
end
