local api = vim.api

-- lyokha/vim-xkbswitch
vim.cmd([[
let g:XkbSwitchLib = '/usr/local/lib/libg3kbswitch.so'
let g:XkbSwitchEnabled = 1
]])


-- akinsho/toggleterm.nvim
-- TODO: fix this annoying bug
--		reproduce:	1. Open terminal (C-t)
--					2. Split it (M-e) twice
--					3. Close all (M-q) * 3
--					4. Reopen terminal, will show term2 instead of 1 and continue to create term2
local toggle_term = require('toggleterm')
toggle_term.setup {
	open_mapping = [[<Nop>]],
	insert_mappings = false,
	terminal_mappings = false,
	direction = 'horizontal',
	size = 20,
	shade_terminals = false,
	highlights = {
		Normal = {
			guibg = '#000000',
			guifg = '#ffffff',
		},
	},
}

local terms = require('toggleterm.terminal')

toggle_or_open_terminal = function(direction)
	-- print("toggle " .. #terms.get_all() .. " hidden " .. #terms.get_all(true))
	if #terms.get_all() == 0 then
		open_new_terminal(direction)
	else
		toggle_term.toggle_all(true)
	end
end

open_new_terminal = function(direction)
	-- Flip directions...
	if direction == 'horizontal' then
		direction = 'vertical'
	else
		direction = 'horizontal'
	end
	local ft = api.nvim_buf_get_option(0, 'filetype')
	local dir = vim.fn.expand('%:p:h')
	if ft == 'toggleterm' then
		-- TODO: this should open in the same dir as the term but it doesn't work
		dir = string.gsub(string.gsub(vim.fn.expand('%:h:h:h'), 'term://', ''), '//.+', '')
	end

	local term = terms.Terminal:new({ id = #terms.get_all() + 1, dir = dir, direction = direction })
	term:open(nil, direction, true)
end

-- chomosuke/term-edit.nvim
require('term-edit').setup {
	prompt_end = '%$ ',
}

-- aduros/ai.vim
vim.g.ai_no_mappings = true

-- chrisgrieser/nvim-various-textobjs
require('various-textobjs').setup {
	useDefaultKeymaps = true,
}
-- Override "sentence" textobj in favor of subword
local vt = require('various-textobjs')
map({ 'o', 'x' }, 'is', function() vt.subword(true) end)
map({ 'o', 'x' }, 'as', function() vt.subword(false) end)
