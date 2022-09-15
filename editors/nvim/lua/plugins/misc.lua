local api = vim.api

require('Comment').setup{
}

require('nvim-autopairs').setup{
	check_ts = true,
	-- enable_moveright = false,
}

local autosave = require('autosave')
autosave.setup{
	clean_command_line_interval = 1000,
	on_off_commands = true,
	execution_message = '',
}

autosave.hook_before_actual_saving = function ()
	mode = vim.api.nvim_get_mode()
	if mode.mode ~= 'n' then -- Don't save while we in insert/select mode (triggered with autopair and such)
		vim.g.auto_save_abort = true
	end
end

require'nvim-lastplace'.setup{
	lastplace_ignore_buftype = {'terminal'}
}

require'sniprun'.setup{
	display = {
		"Classic"
	}
}

require("revj").setup{
	new_line_before_last_bracket = false,
	add_seperator_for_last_parameter = false,
	enable_default_keymaps = true,
}

require('numb').setup{
	number_only = true,
}

local node_relative_path = function(node)
	return vim.fn.fnamemodify(node.absolute_path, ":~:.")
end

local find_in_path = function(node)
	opts = {}
	opts.default_text = '-g"'.. node_relative_path(node) .. '/**" "'
	require('telescope').extensions.live_grep_args.live_grep_args(opts)
end

local git_hist_path = function(node)
	vim.fn.execute('DiffviewFileHistory ' .. node_relative_path(node))
end

require'nvim-tree'.setup {
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = '<Escape>', action = 'close_node' },
				{ key = 'f', action = 'find in path', action_cb = find_in_path },
				{ key = 'gh', action = 'git history in path', action_cb = git_hist_path },
				{ key = '<C-o>', action = 'split' },
			}
		}
	},
	renderer = {
		symlink_destination = false
	}
}

vim.api.nvim_create_user_command('Locate', ':NvimTreeFindFile', {})

vim.cmd([[
let g:XkbSwitchLib = '/usr/local/lib/libg3kbswitch.so'
let g:XkbSwitchEnabled = 1
]])

if IS_REMOTE then
	-- Enable osc(remote) yank
	vim.cmd([[
	autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
	]])
end

vim.g.undotree_WindowLayout = 3 -- undotree at right

-- nvim-peekup
local peekup_config = require('nvim-peekup.config')
peekup_config.on_keystroke['delay'] = ''
peekup_config.on_keystroke['autoclose'] = true
peekup_config.on_keystroke['paste_reg'] = '"'

-- toggleterm.nvim
-- TODO: fix this annoying bug
--		reproduce:	1. Open terminal (C-t)
--					2. Split it (M-e) twice
--					3. Close all (M-q) * 3
--					4. Reopen terminal, will show term2 instead of 1 and continue to create term2
local toggle_term = require('toggleterm')
toggle_term.setup {
	open_mapping = [[<leader>t]],
	insert_mappings = false,
	terminal_mappings = false,
	direction = 'horizontal',
	size = 20,
	shade_terminals = false,
	highlights = {
		Normal = {
			link = 'NvimTreeNormal'
		}
	}
}

local terms = require('toggleterm.terminal')

toggle_or_open_terminal = function(direction)
	print("toggle "..#terms.get_all().. " hidden "..#terms.get_all(true))
	if #terms.get_all() == 0 then
		open_new_terminal(direction)
	else
		toggle_term.toggle_all(true)
	end
end

open_new_terminal = function(direction)
	-- Flip directions...
	if direction == "horizontal" then
		direction = "vertical"
	else
		direction = "horizontal"
	end
	local ft = api.nvim_buf_get_option(0, 'filetype')
	local dir = vim.fn.expand('%:p:h')
	if ft == 'toggleterm' then
		-- TODO: this should open in the same dir as the term but it doesn't work
		dir = string.gsub(string.gsub(vim.fn.expand('%:h:h:h'), "term://", ""), "//.+", "")
	end

	local term = terms.Terminal:new({id = #terms.get_all() + 1, dir = dir, direction = direction})
	term:open(nil, direction, true)
end

-- guess-indent.nvim
require('guess-indent').setup{}

-- refactoring.nvim
require('refactoring').setup{}

-- vim-maximizer
vim.g.maximizer_default_mapping_key = '<M-Z>'

-- rust.vim
-- vim.g.rustfmt_autosave = 1

-- trld.nvim
require('trld').setup{
	auto_cmds = false,
}
vim.api.nvim_create_autocmd('CursorHold', {
	pattern = '*',
	callback = function() TRLDShow() end
})

vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI', 'InsertEnter'}, {
	pattern = '*',
	callback = function() TRLDHide() end
})

-- tmuxjump.vim
vim.g.tmuxjump_telescope = true
vim.g.tmuxjump_custom_capture = "~/dotfiles_scripts/inner/_tmuxjump_capture.sh"

-- todo-comments.nvim
require('todo-comments').setup{
	signs = false,
	highlight = {
		before = '',
		keyword = 'fg',
		after = ''
	},
	colors = {
		error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
		warning = { "TSDanger", "DiagnosticWarning", "WarningMsg", "#FBBF24" },
		info = { "TSWarning", "DiagnosticInfo", "#2563EB" },
		hint = { "TSFuncBuiltin", "DiagnosticHint", "#10B981" },
		default = { "TSNumber", "Identifier", "#7C3AED" },
	},
}

-- iron.nvim - XXX BROKEN
-- require("iron.core").setup {
-- 	config = {
-- 		should_map_plug = false,
-- 		scratch_repl = true,
-- 		repl_definition = {
-- 			sh = {
-- 				command = {"zsh"}
-- 			}
-- 		},
-- 		repl_open_cmd = 'belowright 15 split',
-- 	},
-- 	keymaps = {
-- 		send_motion = "<space>sc",
-- 		visual_send = "<space>sc",
-- 		send_file = "<space>sf",
-- 		send_line = "<space>sl",
-- 		cr = "<space>s<cr>",
-- 		interrupt = "<space>s<space>",
-- 		exit = "<space>sq",
-- 		clear = "<space>cl",
-- 	},
-- 	highlight = {
-- 		italic = false,
-- 		bold = false
-- 	}
-- }

-- nvim-colorizer.lua
require('colorizer').setup{
	'*'
}

-- nvim-pasta
require('pasta').setup{
}

-- color-picker.nvim
require('color-picker').setup{
}

-- go.nvim
require('go').setup{
	lsp_keymaps = false,
	dap_debug_keymap = false,
	textobjects = false,
}

-- markdown-preview.nvim
vim.g.mkdp_auto_close = 0

-- leap.nvim
require('leap').set_default_keymaps()
require('leap').setup {
	max_aot_targets = nil,
	highlight_unlabeled = false,
}

-- flit.nvim
require('flit').setup{
}

-- neoscroll.nvim
local neoscroll = require('neoscroll')
neoscroll.setup{
	mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>'}, -- Dont override zz/zt/zb, C-e, C-y
}
-- Recenter after scroll
local scroll_speed = 150
vim.keymap.set('n', '<C-u>', function()
	neoscroll.scroll(-vim.wo.scroll, true, scroll_speed)
	vim.api.nvim_feedkeys('zz', 'n', false)
end, {})
vim.keymap.set('n', '<C-d>', function()
	neoscroll.scroll(vim.wo.scroll, true, scroll_speed)
	vim.api.nvim_feedkeys('zz', 'n', false)
end, {})

-- scope.nvim
require('scope').setup{
}

-- debugprint.nvim
require('debugprint').setup{
	print_tag = '--- DEBUG PRINT ---'
}

-- nvim-toggler
require('nvim-toggler').setup{
	['to'] = 'from',
	['failed'] = 'succeeded',
}

-- mind.nvim
require('mind').setup{
	keymaps = {
		normal = {
			["<cr>"] = "toggle_node",
			["<Esc>"] = "toggle_parent",
			["e"] = "open_data",
			["dd"] = "delete",
			["<leader>m"] = "quit",
			["R"] = "change_icon_menu",
		},
		selection = {
			["<cr>"] = "toggle_node",
			["e"] = "open_data",
		}
	}
}

require'window-picker'.setup{
}
