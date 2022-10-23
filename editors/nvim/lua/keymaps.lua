---@diagnostic disable: lowercase-global
-- Default bindings https://hea-www.harvard.edu/~fine/Tech/vi.html
local cmd = vim.cmd
local api = vim.api

local default_opts = { silent = true }
local function map(mode, l, r, desc, opts)
	opts = opts or default_opts
	opts.desc = desc
	vim.keymap.set(mode, l, r, opts)
end

local function map_buffer(bufid, mode, l, r, desc, opts)
	opts = opts or default_opts
	opts.buffer = bufid
	opts.desc = desc
	vim.keymap.set(mode, l, r, opts)
end

----------------------------------------------------------------------------------
--
-- This file contains the custom keymaps.
-- Keymaps are set by plugins, to allNavigatekeymaps use :ListKeys
--
-- I tried to stick as close as I can to the vim key mantra.
-- Keybinds are acronyms of the action and will be marked in capital in the comment
--
-- Shift expanding the action to workspace
-- Shift reversing the action (like vim)
--
-- Binds that start with shift, reverse the shift action (to keep shift pressed)
-- Binds that are prefixed with <leader> are more rare
--
--
-- If you are new for nvim/vim I `<M-X>` is 'Alt+x', `<C-x>` is 'Ctrl+x'
--   `x` is 'x', `X` is Shift+X
-- map('MODE', 'BIND', 'ACTION', OPTS(most of them are no re-map and silent))
--
-- nvim is reading the binds through ANSI, so it has some limitation
--   it can't read Ctrl+Shift+KEY, but it can read Alt+Shift+Key.
--   You can see what vim reads with `sed -n l`
--
-- Notice that nvim is the last program that read the binds
--   System(GUI) -> Terminal -> tmux -> nvim
--
----------------------------------------------------------------------------------

-----------------------------------
--     KEYMAPS FROM PLUGINS      --
-----------------------------------
-- leap.nvim: Default
-- gitsigns.nvim: git.lua
-- treesitter-textobjects: treesitter.lua

-- Remap space as leader key
map('', '<Space>', '<Nop>') -- Unmap space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-----------------------------------
--           BUILTIN             --
-----------------------------------
local add_new_line = 'i\\r\\n<Esc>'
map('', '<leader><leader>', ':', 'Enter command with double leader')
map('n', 'n', 'nzz', 'Auto recenter after n')
map('n', '<M-r>', '<cmd>echo "Current File Reloaded!"<cr><cmd>luafile %<cr>', 'Reload current luafile')
map('n', 'n', 'nzz', 'Auto recenter after n')
map('n', 'N', 'Nzz', 'Auto recenter after N')
map('n', '<F3>', '<cmd>let @/ = "not_gonna_find_this_______"<cr>', 'Disable find highlight')
map('n', '<C-o>', '<C-o>zz', 'Recenter after C-o')
map('n', '<C-i>', '<C-i>zz', 'Recenter after C-i')
map('n', '<C-u>', '<C-u>zz', 'recenter after scroll down')
map('n', '<C-d>', '<C-d>zz', 'recenter after scroll down')
map('v', '<Enter>', 'y', 'yank with Enter in visual mode')
map('i', '<C-k>', '<C-O>o', 'Insert new line in insert mode')
map('', '<leader>y', '"+y', 'Start copy to os clipboard E.g: <leader>yy will copy current line to os')
map('', '<leader>Y', '"+y$', 'Copy rest of the line to os clipboard like "Y" but for os clipboard')
map('n', '<leader>p', '"+p', 'paste from os clipboard')
map('n', '<leader>P', '"+P', 'paste from os clipboard')
map({ 'n', 'v', 't' }, '<M-,>', '<cmd>tabprev<cr>', 'Previous tabpage with Alt+, (<). NOT FILE TABS')
map({ 'n', 'v', 't' }, '<M-.>', '<cmd>tabnext<cr>', 'Next tabpage with Alt+. (>). NOT FILE TABS')
map('i', '<M-,>', '<C-O><cmd>tabprev<cr>', 'Previous tabpage with Alt+, (<). NOT FILE TABS')
map('i', '<M-.>', '<C-O><cmd>tabnext<cr>', 'Next tabpage with Alt+. (>). NOT FILE TABS')
map('n', '<leader>n', add_new_line, 'Add newline')
map('x', '<leader>p', '"_dP', 'replace text without changing the copy register')
map('n', '<leader>d', '"_d', 'delete without yanking')
map('n', '<leader>D', '"_D', 'delete without yanking')
map('n', '<leader>c', '"_c', 'change without yanking')
map('n', '<leader>C', '"_C', 'change without yanking')

map('', '<Down>', '<C-e>', 'Down to scroll')
map('', '<Up>', '<C-y>', 'Up to scroll')

-- Move through wrapped lines
map({ 'n', 'x' }, 'j', 'v:count ? "j" : "gj"', 'Move down inside wrapped line', { silent = true, expr = true })
map({ 'n', 'x' }, 'k', 'v:count ? "k" : "gk"', 'Move down inside wrapped line', { silent = true, expr = true })

-- Toggle spell check
map('n', '<F1>', ':set spell!<cr>', 'Toggle spell check')
map('i', '<F1>', '<C-O>:set spell!<cr>', 'Toggle spell check')

-- Search current word without jump
map('n', '*', "<cmd>let @/= '\\<' . expand('<cword>') . '\\>'<cr>zz", 'Search current word without jump')

-----------------------------------
--            Yanky              --
-----------------------------------
map({ 'n', 'x' }, 'y', '<Plug>(YankyYank)', 'Yank with yanky.nvim')
map({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)', 'Paste with yanky.nvim')
map({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)', 'Paste with yank.nvim')

map('n', '<M-[>', '<Plug>(YankyCycleForward)', 'Cycle yank history forward')
map('n', '<M-]>', '<Plug>(YankyCycleBackward)', 'Cycle yank history backward')

-----------------------------------
--             TMUX              --
-----------------------------------
-- Navigate in panes + splits (requires vim-tmux-navigator)
map({ 'n', 't' }, '<C-h>', '<cmd>TmuxNavigateLeft<cr>')
map({ 'n', 't' }, '<C-j>', '<cmd>TmuxNavigateDown<cr>')
map({ 'n', 't' }, '<C-k>', '<cmd>TmuxNavigateUp<cr>')
map({ 'n', 't' }, '<C-l>', '<cmd>TmuxNavigateRight<cr>')
map({ 'n', 't' }, '<M-Left>', '<cmd>TmuxNavigateLeft<cr>')
map({ 'n', 't' }, '<M-Down>', '<cmd>TmuxNavigateDown<cr>')
map({ 'n', 't' }, '<M-Up>', '<cmd>TmuxNavigateUp<cr>')
map({ 'n', 't' }, '<M-Right>', '<cmd>TmuxNavigateRight<cr>')
map({ 'n', 't' }, '<leader>o', '<cmd>TmuxJumpFile<cr>', 'Open file pathes from sibiling tmux pane')
-- Splits like tmux
map('n', '<M-e>', function() smart_split('vertical') end, 'Vsplit')
map('n', '<M-o>', function() smart_split('horizontal') end, 'split')

map('n', '<M-q>', close_pane, 'Close pane')
map('n', '<M-w>', close_pane, 'Close pane')

-----------------------------------
--           TERMINAL            --
-----------------------------------
map('t', '<Esc>', '<C-\\><C-n>') -- Escape from terminal with escape key


-- Duplicate your view into split (MAX 2)
map('n', 'gV', function() split_if_not_exist(true) end, 'Vertical split if not exist')
map('n', 'gX', function() split_if_not_exist(false) end, 'Horziontal split if not exist')

-----------------------------------
--          MISC PLUGINS         --
-----------------------------------
map('n', '<F8>', '<cmd>UndotreeToggle<CR>', 'Toggle undotree')
map('n', '<leader>b', '<cmd>Telescope buffers<CR>', 'Browse open buffers')
map('n', '<leader>gx', require('open').open_cword, 'Open current word')
map('n', '<leader>rgb', '<cmd>PickColor<CR>', 'Pick color')
map({ 'n', 't', 'v' }, '<C-t>', function() toggle_or_open_terminal() end, 'toggle all terminals')
map('t', '<M-e>', function() open_new_terminal('vertical') end, 'Split terminal')
map('t', '<M-q>', '<cmd>bd!<CR>', 'Close terminal')
map('n', ']d', require('goto-breakpoints').next, 'Goto next breakpoint')
map('n', '[d', require('goto-breakpoints').prev, 'Goto prev breakpoint')
map('n', '<leader>m', require('mind').open_main, 'Open mind.nvim')
map('n', '<leader>e', require('femaco.edit').edit_code_block, 'Edit markdown codeblocks')
map('n', '<leader>w', require('typebreak').start, 'typebreak') -- <leader>Wpm

-- Spell Suggest
map('n', '<leader>ss', function()
	require('telescope.builtin').spell_suggest({
		prompt_title = '',
		layout_config = {
			height = 0.25,
			width = 0.25
		}
	})
end, 'Spell suggest')

map('n', '<leader>sy', function()
	require('telescope').extensions.dict.synonyms({
		prompt_title = '',
		layout_config = {
			height = 0.4,
			width = 0.60
		}
	})
end, 'Synonyms')

-- Mutli Cursors Binds alt+d (like ctrl+d in subl)
-- Add cursor down/up Alt+n/p (like ctrl+down/up in subl)
cmd([[
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<M-d>'
let g:VM_maps['Find Subword Under'] = '<M-d>'
let g:VM_maps['Add Cursor Down'] = '<M-n>'
let g:VM_maps['Add Cursor Up'] = '<M-p>'
]])

-- Surround words
map('n', '<leader>sw', '<leader>saiw', 'Surround word', { remap = true })
map('n', '<leader>sW', '<leader>saiW', 'Surround WORD', { remap = true })
-- Replace qoutes
local qoutes = { "'", '"', '`' }
for _, char in ipairs(qoutes) do
	map('n', "<leader>" .. char, '<leader>srq' .. char, 'Replace surround to ' .. char, { remap = true }) -- <leader>{char} to replace sandwich to {char}
end

-----------------------------------
--        CODE NAVIGATION        --
-----------------------------------
local find_current_file = function()
	local current_file = vim.fn.expand('%:t:r')
	require("telescope.builtin").find_files({
		default_text = current_file,
		hidden = true,
		follow = true,
	})
end

map('n', 'KR', '<cmd>Telescope resume<cr>', 'Resume last telescope')
map('n', 'KL', function() require("telescope.builtin").find_files({ hidden = true, follow = true }) end, 'Find files')
map('n', '<leader>t', find_current_file, 'find files with the current file (use to find _test fast)')
map('n', 'Kd',
	function() require("telescope.builtin").find_files({ hidden = true, follow = true,
			default_text = vim.fn.expand("<cword>") })
	end, 'find files (ctrl+p) starting with current word')
map('v', 'KL',
	'<Esc><cmd>lua require("telescope.builtin").find_files({hidden=true, follow=true, default_text=get_visual_text()})<cr>'
	, 'find files text from visual')
map('n', 'KJ', live_grep, 'search in all files (fuzzy finder)')
map('v', 'KJ', '<Esc><cmd>lua live_grep({}, "v")<cr>', 'search in all files (default text is from visual)')
map('n', 'KD', function() live_grep({ default_text = vim.fn.expand("<cword>") }) end,
	'Search in all files with current word inserted')
map('n', 'KF', ':set opfunc=LiveGrepRawOperator<CR>g@', 'Search in all files with word from move operator')
vim.cmd("function! LiveGrepRawOperator(...) \n lua live_grep({}, 'n') \n endfunction") -- used by `KF`
map('n', 'Kjj',
	function() live_grep({ default_text = '-g"' .. vim.fn.fnamemodify(vim.fn.expand("%"), ":.:h") .. '/*" -F "' }) end,
	'Search in all files in your current directory')
map('n', 'Kjd',
	function() live_grep({ default_text = vim.fn.expand("<cword>") ..
			' -g"' .. vim.fn.fnamemodify(vim.fn.expand("%"), ":.:h") .. '/*"' })
	end, 'Search in all files in your current directory + with your current word')


-----------------------------------
--             LSP               --
-----------------------------------
-- Builtin LSP Binds
map('n', 'gD', vim.lsp.buf.declaration, 'Go to Declaration')
map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, 'Format')

-- Telescope LSP Binds
map('n', 'gd', goto_def, 'Go to Definition')
map('n', '<C-LeftMouse>', function()
	vim.api.nvim_input('<LeftMouse>')
	vim.api.nvim_input('<cmd>vsplit<cr>')
	goto_def()
end, 'Go to Definition in split')

map('n', '<MiddleMouse>', function()
	vim.api.nvim_input('<LeftMouse>')
	goto_def()
end, 'Go to Definition')

local lsp_implementations = function()
	require 'telescope.builtin'.lsp_implementations {
		show_line = false
	}
end

map('n', 'gvd', function() split_if_not_exist(true) goto_def() end, 'Go to Definition in Vsplit')
map('n', 'gxd', function() split_if_not_exist(false) goto_def() end, 'Go to Definition in Xsplit')
map('n', 'god', function() split_if_not_exist(false) goto_def() end, 'Go to Definition in Xsplit')
map('n', 'gKD',
	function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ default_text = vim.fn.expand("<cword>") }) end,
	'Go to definition under current word')
map('n', 'gi', lsp_implementations, 'Go to Implementation')
map('n', 'gvi', function() split_if_not_exist(true) lsp_implementations() end, 'Go to Implementation in Vsplit')
map('n', 'gxi', function() split_if_not_exist(false) lsp_implementations() end, 'Go to Implementation in Xsplit')
map('n', 'goi', function() split_if_not_exist(false) lsp_implementations() end, 'Go to Implementation in Xsplit')
map('n', 'gt', require 'telescope.builtin'.lsp_type_definitions, 'Go to Type')
map('n', 'gvt', function() split_if_not_exist(true) require 'telescope.builtin'.lsp_type_definitions {} end,
	'Go to Type in Vsplit')
map('n', 'gxt', function() split_if_not_exist(false) require 'telescope.builtin'.lsp_type_definitions {} end,
	'Go to Type in Xsplit')
map('n', 'got', function() split_if_not_exist(false) require 'telescope.builtin'.lsp_type_definitions {} end,
	'Go to Type in Xsplit')

local lsp_references = function()
	require 'telescope.builtin'.lsp_references({
		include_declaration = false,
		show_line = false
	})
end
map('n', 'gs', function() require 'telescope.builtin'.lsp_document_symbols({ fname_width = 100 }) end, 'Go Symbols')
map('n', 'gS', require 'telescope.builtin'.lsp_dynamic_workspace_symbols, 'Go workspace Symbols')
map('n', 'gr', lsp_references, 'Go to References')
map('n', 'gvr', function() split_if_not_exist(true) lsp_references() end, 'Go to References in Vsplit')
map('n', 'gxr', function() split_if_not_exist(false) lsp_references() end, 'Go to References in Xsplit')
map('n', 'gor', function() split_if_not_exist(false) lsp_references() end, 'Go to References xsplit')
map('n', 'gp', function() require 'telescope.builtin'.diagnostics { bufnr = 0 } end, 'Go to Problems')
map('n', 'gP', require 'telescope.builtin'.diagnostics, 'Go to workspace Problems')

-- RRethy/vim-illuminate
map('n', '<C-n>', function() require "illuminate".goto_next_reference({ wrap = true }) end,
	'jump to Next occurrence of var on cursor')
map('n', '<C-p>', function() require "illuminate".goto_prev_reference({ reverse = true, wrap = true }) end,
	'jump to Previous occurrence of var on cursor')

-- Lsp UI
map('n', '<F2>', '<cmd>Lspsaga rename<cr>', 'Rename symbos with F2')
map('n', '<leader><F2>', '*:%s///g<left><left>', 'Rename current word with <leader>F2')
map('x', '<F2>', '"hy:%s/<C-r>h//g<left><left>', 'Rename visual')
map('n', '<F4>', '<cmd>Lspsaga code_action<cr>', 'Code action with F4')
map('n', 'KK', '<cmd>Lspsaga hover_doc<cr>', 'Trigger hover (KJ is fast to use)')
map('n', '<RightMouse>', '<LeftMouse><cmd>Lspsaga hover_doc<cr>', 'Trigger hover')
map('n', '<leader>i', '<cmd>Neogen<cr>', 'document function')
map('n', '<leader>l', require('lsp_lines').toggle, 'show Problem')
map('n', '<leader>L', '<cmd>Lspsaga show_line_diagnostics<CR>', 'show Problem')
map('n', ']p', goto_next_diag, 'next Problem')
map('n', '[p', goto_prev_diag, 'prev Problem')
map('n', ']g', goto_next_diag, 'next Problem')
map('n', '[g', goto_prev_diag, 'prev Problem')

-----------------------------------
--             GIT               --
-----------------------------------
map('n', '<leader>gs', '<cmd>:G<CR>', 'Open fugitive.vim (git status)')
map('n', '<leader>gD', '<cmd>Easypick dirtyfiles<CR>', 'Git dirtyfiles')
map('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', 'Git show diff')
map('n', '<leader>gS', '<cmd>DiffviewOpen HEAD^..HEAD<CR>', 'Git Show')
map('n', '<leader>gc', '<cmd>Telescope git_branches<CR>', 'Git checkout')
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', 'Git History')
map('n', '<leader>gH', '<cmd>DiffviewFileHistory .<CR>', 'Git workspace History')
map('n', '<leader>gt', '<cmd>vert Flogsplit<CR>', 'Git Tree')
map('n', '<leader>got', '<cmd>Flogsplit<CR>', 'Git Tree (split)')
map('n', '<leader>hh', '<cmd>GitMessenger<CR>', 'Hunk history')
map('n', 'gh', ':set opfunc=GitHistoryOperator<CR>g@',
	'show Git History with operator, e.g: gh3<cr> shows the history of the 3 lines below')
map('v', 'gh', '<Esc><cmd>lua git_history("v")<cr>', 'show Git History with visual mode')
vim.cmd("function! GitHistoryOperator(...) \n lua git_history('n') \n endfunction") -- used by `gh`

-----------------------------------
--             UI                --
-----------------------------------
-- File Sidebar
map('n', '<M-m>', '<cmd>NvimTreeToggle<cr>', 'Toggle file tree')
map('n', '<M-M>', '<cmd>NvimTreeFindFile<cr>', 'Locate file')

-- Tabline binds
map('n', '<C-q>', function() require('bufdelete').bufdelete(0, true) end, 'Close current tab')
map('n', '<leader>1', function() require('bufferline').go_to_buffer(1, true) end, 'Go to tab #1')
map('n', '<leader>2', function() require('bufferline').go_to_buffer(2, true) end, 'Go to tab #2')
map('n', '<leader>3', function() require('bufferline').go_to_buffer(3, true) end, 'Go to tab #3')
map('n', '<leader>4', function() require('bufferline').go_to_buffer(4, true) end, 'Go to tab #4')
map('n', '<leader>5', function() require('bufferline').go_to_buffer(5, true) end, 'Go to tab #5')
map('n', '<leader>6', function() require('bufferline').go_to_buffer(6, true) end, 'Go to tab #6')
map('n', '<leader>7', function() require('bufferline').go_to_buffer(7, true) end, 'Go to tab #7')
map('n', '<leader>8', function() require('bufferline').go_to_buffer(8, true) end, 'Go to tab #8')
map('n', '<leader>9', function() require('bufferline').go_to_buffer(9, true) end, 'Go to tab #9')
map('n', '<leader>0', function() require('bufferline').go_to_buffer(10, true) end, 'Go to tab #10')
-- Tab control, tmux binds are "outer" Alt+h/l and vim is "inner" Alt+j/k
map('n', '<M-j>', '<cmd>BufferLineCyclePrev<CR>', 'Alt+j to move to left')
map('n', '<M-k>', '<cmd>BufferLineCycleNext<CR>', 'Alt+k to move to right')
map('n', '<M-J>', '<cmd>BufferLineMovePrev<CR>', 'Alt+Shift+j grab to with you to left')
map('n', '<M-K>', '<cmd>BufferLineMoveNext<CR>', 'Alt+Shift+k grab to with you to right')

-- Tabpage binds
map('n', 'g1', '<cmd>tabnext1<cr>', 'Go to tabpage #1')
map('n', 'g2', '<cmd>tabnext2<cr>', 'Go to tabpage #2')
map('n', 'g3', '<cmd>tabnext3<cr>', 'Go to tabpage #3')
map('n', 'g4', '<cmd>tabnext4<cr>', 'Go to tabpage #4')
map('n', 'g5', '<cmd>tabnext5<cr>', 'Go to tabpage #5')
map('n', 'g6', '<cmd>tabnext6<cr>', 'Go to tabpage #6')
map('n', 'g7', '<cmd>tabnext7<cr>', 'Go to tabpage #7')
map('n', 'g8', '<cmd>tabnext8<cr>', 'Go to tabpage #8')
map('n', 'g9', '<cmd>tabnext9<cr>', 'Go to tabpage #9')
map('n', 'g0', '<cmd>tabnext10<cr>', 'Go to tabpage #10')
map('n', 'gq', '<cmd>tabclose<cr>', 'Close tabpage')

-----------------------------------
--          DEBUGGING            --
-----------------------------------
-- TODO: create hydra for it
map('n', '<F5>', require 'dap'.continue, 'Debug: continue')
map('n', '<F6>', require 'dap'.terminate, 'Debug: terminate')
map('n', '<F9>', require('persistent-breakpoints.api').toggle_breakpoint, 'Debug: Toggle breakpoint')
map('n', '<leader><F9>', require('persistent-breakpoints.api').set_conditional_breakpoint, 'Debug: toggle conditional breakpoint')

map('n', '<F10>', function() require 'dap'.step_over() center_screen() end, 'Debug: step over')
map('n', '<F11>', function() require 'dap'.step_into() center_screen() end, 'Debug: step into')
map('n', '<F12>', function() require 'dap'.step_out() center_screen() end, 'Debug: set out')

map('n', '<leader>rp', require 'dap'.repl.open, 'Debug: open repl')

map('n', '<leader>k', require 'dapui'.eval, 'Devug: evaluate')

-----------------------------------
--         File Specific         --
-----------------------------------
-- TODO: unload (using keymap layer like in hydra)
local keys_by_ft = {
	-- Golang
	['go'] = function(bufid)
		map_buffer(bufid, 'n', '<leader>e', '<cmd>GoIfErr<cr>', 'Golang: create if err')
		map_buffer(bufid, 'n', '<leader>ln', '<cmd>s/Println/Printf/<cr>$F"' .. add_new_line, 'Golang: change println to printf')
	end,
	-- Rust
	['rust'] = function(bufid)
		map_buffer(bufid, 'n', 'J', require('rust-tools').join_lines.join_lines, 'Rust: join line')
		map_buffer(bufid, 'n', '<leader>rr', require('rust-tools').runnables.runnables, 'Rust: run')
		map_buffer(bufid, 'n', '<leader>rt', require('rust-tools').hover_actions.hover_actions, 'Rust: run test') -- run test
	end,
	-- Floggraph
	['floggraph'] = function(bufid)
		map_buffer(bufid, 'n', '<C-d>', flog_diff_current, 'Floggraph: show diff from head to current')
		map_buffer(bufid, 'n', '<C-s>', flog_show_current, 'Floggraph: show current in diffview')
		-- TODO: visual selection of multiple commits to diff/show
	end
}
keymaps_autocmd_group = api.nvim_create_augroup('KeyMaps', {})

api.nvim_create_autocmd('FileType', {
	group = keymaps_autocmd_group,
	pattern = "*",
	callback = function(events)
		local buf_ft = events.match
		for ft, set_keys_func in pairs(keys_by_ft) do
			if buf_ft == ft then
				set_keys_func(events.buf)
			end
		end
	end
})
