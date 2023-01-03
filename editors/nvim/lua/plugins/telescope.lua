if vim.g.started_by_firenvim then
	do return end
end

local layout = 'horizontal'
if NVLOG then
	layout = 'vertical'
end

require('telescope').setup {
	defaults = {
		dynamic_preview_title = true,
		mappings = {
			i = {
				['<C-j>'] = 'move_selection_next',
				['<C-k>'] = 'move_selection_previous',
				['<C-n>'] = 'cycle_history_next',
				['<C-p>'] = 'cycle_history_prev',
				['<CR>'] = require('telescope.actions').select_default + require('telescope.actions').center,
				['<C-x>'] = require('telescope.actions').select_horizontal + require('telescope.actions').center,
				['<C-v>'] = require('telescope.actions').select_vertical + require('telescope.actions').center,
				['<C-t>'] = require('telescope.actions').select_tab + require('telescope.actions').center,
			},
			n = {
				['<C-j>'] = 'move_selection_next',
				['<C-k>'] = 'move_selection_previous',
				['<C-o>'] = 'select_horizontal',
				['<CR>'] = require('telescope.actions').select_default + require('telescope.actions').center,
				['<C-x>'] = require('telescope.actions').select_horizontal + require('telescope.actions').center,
				['<C-v>'] = require('telescope.actions').select_vertical + require('telescope.actions').center,
				['<C-t>'] = require('telescope.actions').select_tab + require('telescope.actions').center,
			}
		},
		layout_config = {
			horizontal = {
				width = 0.90,
				preview_width = 0.5,
				height = 0.90
			},
			vertical = {
				width = 0.95,
				preview_height = 0.75,
				height = 0.90
			},
		},
		prompt_prefix = ' ',
		layout_strategy = layout,
	},
	pickers = {
	},
	extensions = {
		['ui-select'] = {
			require('telescope.themes').get_dropdown {
			}
		}
	}
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
require('telescope').load_extension('harpoon')
