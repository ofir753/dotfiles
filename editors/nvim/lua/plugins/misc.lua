require('Comment').setup{
}

require('nvim-autopairs').setup{
    check_ts = true,
	-- enable_moveright = false,
}

require('autosave').setup{
	clean_command_line_interval = 1000,
	on_off_commands = true,
}

require'nvim-lastplace'.setup{
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
}


find_in_path = function(node)
	local relative_path = vim.fn.fnamemodify(node.absolute_path, ":~:.")

	opts = {}
	opts.default_text = '-g"'.. relative_path .. '/**" "'
	require('telescope').extensions.live_grep_raw.live_grep_raw(opts)
end


local tree_cb = require'nvim-tree.config'.nvim_tree_callback
require'nvim-tree'.setup {
	view = {
		mappings = {
			list = {
				{ key = "<Escape>", action = "close_node" },
				{ key = "f", action = "find in path", action_cb = find_in_path },
			}
		}
	}
}

vim.cmd([[
command! Locate execute 'NvimTreeFindFile'
]])

vim.cmd([[
let g:XkbSwitchLib = '/usr/local/lib/libg3kbswitch.so'
let g:XkbSwitchEnabled = 1
]])

-- venn.nvim: enable or disable keymappings
function _G.Toggle_Draw()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "KJ", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "KK", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "<Escape>", ":lua Toggle_Draw()<CR>", {noremap = true})
		print('Entered Draw Mode')
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
		print('Exited Draw Mode')
    end
end

vim.cmd([[
command! Draw execute 'lua Toggle_Draw()'
]])

local is_remote = file_exists(os.getenv("HOME") .. "/.remote_indicator")

if is_remote then
	-- Enable osc(remote) yank
	vim.cmd([[
	autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
	]])
end

vim.g.undotree_WindowLayout = 3 -- undotree at right

-- registers.nvim
vim.g.registers_show = '\"*+-/_=#%.0123456789abcdefghijklmnopqrstuvwxyz:' -- move " register to first
vim.g.registers_paste_in_normal_mode = 2

-- toggleterm.nvim
require("toggleterm").setup {
	open_mapping = [[<leader>t]],
	-- hide_numbers = true,
	-- shade_terminals = false,
	-- start_in_insert = true,
	insert_mappings = false,
	-- terminal_mappings = true,
	-- persist_size = true,
	direction = 'horizontal',
	-- close_on_exit = true, -- close the terminal window when the process exits
	-- shell = vim.o.shell, -- change the default shell
}
