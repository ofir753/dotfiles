---@diagnostic disable: lowercase-global
-- Default bindings https://hea-www.harvard.edu/~fine/Tech/vi.html
local cmd = vim.cmd

local function map(mode, l, r, opts)
	opts = opts or { silent=true }
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

-----------------------------------
--           BUILTIN             --
-----------------------------------
map('n', '<M-r>', '<cmd>echo "Current File Reloaded!"<cr><cmd>luafile %<cr>') -- Reload current luafile
map('n', 'n', 'nzz') -- Auto recenter after n
map('n', 'N', 'Nzz') -- Auto recenter after N
map('n', '<F3>', '<cmd>let @/ = "not_gonna_find_this_______"<cr>') -- Disable find highlight
map('n', '<C-o>', '<C-o>zz') -- Recenter after C-o
map('n', '<C-i>', '<C-i>zz') -- Recenter after C-i
map('v', '<Enter>', 'y') -- yank with Enter in visual mode
map('i', '<C-k>', '<C-O>o') -- Insert new line in insert mode
map('', '<M-y>', '"+y') -- Start copy to os clipboard E.g: M-yy will copy current line to os
map('', '<M-Y>', '"+y$') -- Copy rest of the line to os clipboard like "Y" but for os clipboard
map('n', '<M-v>', '"+p') -- paste from os clipboard
map('n', '<M-V>', '"+P') -- paste from os clipboard
map({'n', 'v', 't'}, '<M-,>', '<cmd>tabprev<cr>') -- Previous tabpage with Alt+, (<). NOT FILE TABS
map({'n', 'v', 't'}, '<M-.>', '<cmd>tabnext<cr>') -- Next tabpage with Alt+. (>). NOT FILE TABS
map('i', '<M-,>', '<C-O><cmd>tabprev<cr>') -- Previous tabpage with Alt+, (<). NOT FILE TABS
map('i', '<M-.>', '<C-O><cmd>tabnext<cr>') -- Next tabpage with Alt+. (>). NOT FILE TABS

map('', '<Down>', '<C-e>') -- Down to scroll
map('', '<Up>', '<C-y>') -- Up to scroll

-- Remap space as leader key
map('', '<Space>', '<Nop>') -- Unmap space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Move through wrapped lines
map({'n', 'x'}, 'j', 'v:count ? "j" : "gj"', { silent = true, expr = true})
map({'n', 'x'}, 'k', 'v:count ? "k" : "gk"', { silent = true, expr = true})

-- Toggle spell check
map('n', '<F1>', ':set spell!<cr>')
map('i', '<F1>', '<C-O>:set spell!<cr>')

-- Search current word without jump
map('n', '*', "<cmd>let @/= '\\<' . expand('<cword>') . '\\>'<cr>zz")

-----------------------------------
--             TMUX              --
-----------------------------------
-- Navigate in panes + splits (requires vim-tmux-navigator)
map({'n', 't'}, '<C-h>', '<cmd>TmuxNavigateLeft<cr>')
map({'n', 't'}, '<C-j>', '<cmd>TmuxNavigateDown<cr>')
map({'n', 't'}, '<C-k>', '<cmd>TmuxNavigateUp<cr>')
map({'n', 't'}, '<C-l>', '<cmd>TmuxNavigateRight<cr>')
map({'n', 't'}, '<M-Left>', '<cmd>TmuxNavigateLeft<cr>')
map({'n', 't'}, '<M-Down>', '<cmd>TmuxNavigateDown<cr>')
map({'n', 't'}, '<M-Up>', '<cmd>TmuxNavigateUp<cr>')
map({'n', 't'}, '<M-Right>', '<cmd>TmuxNavigateRight<cr>')
map({'n', 't'}, '<leader>o', '<cmd>TmuxJumpFile<cr>') -- Open file pathes from sibiling tmux pane
-- Splits like tmux
map('n', '<M-e>', function() smart_split('vertical') end)
map('n', '<M-o>', function() smart_split('horizontal') end)

map('n', '<M-q>', close_pane)
map('n', '<M-w>', close_pane) -- close pane like tmux

-----------------------------------
--           TERMINAL            --
-----------------------------------
map('t', '<Esc>', '<C-\\><C-n>') -- Escape from terminal with escape key


-- Duplicate your view into split (MAX 2)
map('n', 'gV', function() split_if_not_exist(true) end)
map('n', 'gX', function() split_if_not_exist(false) end)

-----------------------------------
--          MISC PLUGINS         --
-----------------------------------
map('n', '<F8>', '<cmd>UndotreeToggle<CR>') -- Toggle undotree
map('n', '<leader>b', '<cmd>Telescope buffers<CR>') -- browse your open Buffers (tabs)
map('n', '<leader>c', '<cmd>Telescope command_history<CR>') -- history of Commands
map('n', '<leader>gx', '<cmd>call OpenInBrowser()<CR>')
map('n', '<leader>cp', '<cmd>PickColor<CR>')
-- map({'n', 'x'}, 'p', require('pasta.mappings').p) -- override paste with smarter paste
-- map({'n', 'x'}, 'P', require('pasta.mappings').P) -- override paste with smarter paste
map({'n', 'x', 'o'}, '<leader>l', require'leap-ast'.leap) -- Leap to treesitter objects
map({'n', 't', 'v'}, '<C-t>', function() toggle_or_open_terminal() end) -- toggle all terminals
map('t', '<M-e>', function() open_new_terminal('vertical') end) -- Split terminal
map('t', '<M-q>', function() require('bufdelete').bufdelete(0, true) end) -- Close terminal
map('n', ']d', require('goto-breakpoints').next)
map('n', '[d', require('goto-breakpoints').prev)
map('n', '<leader>m', require('mind').open_main)

-- Mutli Cursors Binds alt+d (like ctrl+d in subl)
-- Add cursor down/up Alt+n/p (like ctrl+down/up in subl)
cmd([[
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<M-d>'
let g:VM_maps['Find Subword Under'] = '<M-d>'
let g:VM_maps['Add Cursor Down'] = '<M-n>'
let g:VM_maps['Add Cursor Up'] = '<M-p>'
]])

-- Adding <leader> prefix for sandwich to avoid conflicting with leap.nvim
vim.g.sandwich_no_default_key_mappings = 1
local sandwich_opts = {}
-- add
map({'n', 'x', 'o'}, '<leader>sa', '<Plug>(sandwich-add)', sandwich_opts)
-- add current line as a block (convert single line ifs to blocked ifs)
map('n', '<leader>Sa', 'V<Plug>(sandwich-add)', sandwich_opts)
-- delete
map({'n', 'x'}, '<leader>sd', '<Plug>(sandwich-delete)', sandwich_opts)
map('n', '<leader>sdb', '<Plug>(sandwich-delete-auto)', sandwich_opts)
-- replace
map({'n', 'x'}, '<leader>sr', '<Plug>(sandwich-replace)', sandwich_opts)
map('n', '<leader>srb', '<Plug>(sandwich-replace-auto)', sandwich_opts)
-- sandwich word
map('n', '<leader>sw', '<Plug>(sandwich-add)iw', sandwich_opts)
map('n', '<leader>sW', '<Plug>(sandwich-add)iW', sandwich_opts)
-- Some special cases
map('n', "<leader>'", '<Plug>(sandwich-replace)"\'', sandwich_opts) -- replace " with '
map('n', '<leader>"', '<Plug>(sandwich-replace)\'"', sandwich_opts) -- replace ' with "

-----------------------------------
--        CODE NAVIGATION        --
-----------------------------------
map('n', 'KR', '<cmd>Telescope resume<cr>') -- Resume last telescope
map('n', 'KL', function() require("telescope.builtin").find_files({hidden=true, follow=true}) end) -- find files (ctrl+p)
map('n', 'Kd', function() require("telescope.builtin").find_files({hidden=true, follow=true, default_text = vim.fn.expand("<cword>")}) end) -- find files (ctrl+p) starting with current word
map('v', 'KL', '<Esc><cmd>lua require("telescope.builtin").find_files({hidden=true, follow=true, default_text=get_visual_text()})<cr>') -- find files text from visual
map('n', 'KJ', live_grep) -- search in all files (fuzzy finder)
map('v', 'KJ', '<Esc><cmd>lua live_grep({}, "v")<cr>') -- search in all files (default text is from visual)
map('n', 'KD', function() live_grep({default_text = vim.fn.expand("<cword>")}) end) -- Search in all files with current word inserted
map('n', 'KF', ':set opfunc=LiveGrepRawOperator<CR>g@') -- Search in all files with word from move operator
vim.cmd("function! LiveGrepRawOperator(...) \n lua live_grep({}, 'n') \n endfunction") -- used by `KF`
map('n', 'Kjj', function() live_grep({default_text = '-g"' .. vim.fn.fnamemodify(vim.fn.expand("%"), ":.:h") .. '/*" -F "'}) end) -- Search in all files in your current directory
map('n', 'Kjd', function() live_grep({default_text = vim.fn.expand("<cword>") .. ' -g"' .. vim.fn.fnamemodify(vim.fn.expand("%"), ":.:h") .. '/*"'}) end) -- Search in all files in your current directory + with your current word


-----------------------------------
--             LSP               --
-----------------------------------
-- Builtin LSP Binds
map('n', '<leader>f', function() vim.lsp.buf.format{async = true} end) -- Format code
map('v', '<leader>f', '<Esc><cmd>lua vim.lsp.buf.range_formatting()<cr>') -- range Format code
map('n', 'gD', vim.lsp.buf.declaration) -- Go to Declaration

-- Telescope LSP Binds
map('n', 'gd', goto_def) -- Go to Definition
map('n', '<C-LeftMouse>', function()
	vim.api.nvim_input('<LeftMouse>')
	vim.api.nvim_input('<cmd>vsplit<cr>')
	goto_def()
end) -- Go to Definition in split

map('n', '<MiddleMouse>', function()
	vim.api.nvim_input('<LeftMouse>')
	goto_def()
end) -- Go to Definition

local lsp_implementations = function()
	require'telescope.builtin'.lsp_implementations{
		show_line = false
	}
end

map('n', 'gvd', function() split_if_not_exist(true) goto_def() end) -- Go to Definition in Vsplit
map('n', 'gxd', function() split_if_not_exist(false) goto_def() end) -- Go to Definition in Xsplit
map('n', 'god', function() split_if_not_exist(false) goto_def() end) -- Go to Definition in Xsplit
map('n', 'gKD', function() require("telescope.builtin").lsp_dynamic_workspace_symbols({default_text = vim.fn.expand("<cword>")}) end) -- (Go) search Definition under current word
map('n', 'gi', lsp_implementations) -- Go to Implementation
map('n', 'gvi', function() split_if_not_exist(true) lsp_implementations() end) -- Go to Implementation in Vsplit
map('n', 'gxi', function() split_if_not_exist(false) lsp_implementations() end) -- Go to Implementation in Xsplit
map('n', 'goi', function() split_if_not_exist(false) lsp_implementations() end) -- Go to Implementation in Xsplit
map('n', 'gt', require'telescope.builtin'.lsp_type_definitions) -- Go to Type
map('n', 'gvt', function() split_if_not_exist(true) require'telescope.builtin'.lsp_type_definitions{} end) -- Go to Type in Vsplit
map('n', 'gxt', function() split_if_not_exist(false) require'telescope.builtin'.lsp_type_definitions{} end) -- Go to Type in Xsplit
map('n', 'got', function() split_if_not_exist(false) require'telescope.builtin'.lsp_type_definitions{} end) -- Go to Type in Xsplit

local lsp_references = function()
	require'telescope.builtin'.lsp_references({
		include_declaration = false,
		show_line = false
	})
end
map('n', 'gs', function() require'telescope.builtin'.lsp_document_symbols({fname_width=100}) end) -- Go Symbols
map('n', 'gS', require'telescope.builtin'.lsp_dynamic_workspace_symbols) -- Go workspace (S)ymbols
map('n', 'gr', lsp_references) -- Go to References
map('n', 'gvr', function() split_if_not_exist(true) lsp_references() end) -- Go to References in Vsplit
map('n', 'gxr', function() split_if_not_exist(false) lsp_references() end) -- Go to References in Xsplit
map('n', 'gor', function() split_if_not_exist(false) lsp_references() end) -- Go to References xsplit
map('n', 'gp', function() require'telescope.builtin'.diagnostics{bufnr=0} end) -- Go to Problems
map('n', 'gP', require'telescope.builtin'.diagnostics) -- Go to workspace (P)roblems

-- illumante
map('n', '<C-n>', function() require"illuminate".next_reference{wrap=true} end) -- jump to Next occurrence of var on cursor
map('n', '<C-p>', function() require"illuminate".next_reference{reverse=true,wrap=true} end) -- jump to Previous occurrence of var on cursor

-- Lsp UI
map('n', '<F2>', '<cmd>Lspsaga rename<cr>') -- Rename symbols with F2
map('n', '<F4>', '<cmd>Lspsaga code_action<cr>') -- Code action with F4
map('n', 'KK',  '<cmd>Lspsaga hover_doc<cr>') -- Trigger hover (KJ is fast to use)
map('n', '<RightMouse>',  '<LeftMouse><cmd>Lspsaga hover_doc<cr>') -- Trigger hover
map('n', '<leader>d',  '<cmd>Neogen<cr>') -- Document function
map('n', '<leader>p', require('lsp_lines').toggle) -- show Problem
map('n', ']p', goto_next_diag) -- next Problem
map('n', '[p', goto_prev_diag) -- prev Problem
map('n', ']g', goto_next_diag) -- next Problem
map('n', '[g', goto_prev_diag) -- prev Problem
map('n', '<C-u>', function() require("lspsaga.action").smart_scroll_with_saga(-1) end, {}) -- scroll Up in document
map('n', '<C-d>', function() require("lspsaga.action").smart_scroll_with_saga(1) end, {}) -- scroll Down in Document

-----------------------------------
--             GIT               --
-----------------------------------
map('n', '<leader>gs', '<cmd>:G<CR>') -- Open fugitive.vim (git status)
map('n', '<leader>gD', '<cmd>Easypick dirtyfiles<CR>') -- Git dirtyfiles
map('n', '<leader>gd', '<cmd>DiffviewOpen<CR>') -- Git Sdiff
map('n', '<leader>gS', '<cmd>DiffviewOpen HEAD^..HEAD<CR>') -- Git Show
map('n', '<leader>gc', '<cmd>Telescope git_branches<CR>') -- Git checkout
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>') -- Git History
map('n', '<leader>gH', '<cmd>DiffviewFileHistory .<CR>') -- Git workspace History
map('n', '<leader>gt', '<cmd>Flogsplit<CR>') -- Git Tree
map('n', '<leader>hh', '<cmd>GitMessenger<CR>')
map('n', 'gh', ':set opfunc=GitHistoryOperator<CR>g@') -- show Git History with operator, e.g: gh3<cr> shows the history of the 3 lines below
map('v', 'gh', '<Esc><cmd>lua git_history("v")<cr>') -- show Git History with visual mode
vim.cmd("function! GitHistoryOperator(...) \n lua git_history('n') \n endfunction") -- used by `gh`

-- apply patches in 3 way split diff aka :SolveConflict
-- TODO: after getting a good conflict solver rebind it with autocmd
-- map('n', '<C-[>', '<cmd>diffget //2<CR>') -- Apply left change
-- map('n', '<C-]>', '<cmd>diffget //3<CR>') -- Apply right change

-----------------------------------
--             UI                --
-----------------------------------
-- File Sidebar
map('n', '<M-m>', '<cmd>NvimTreeToggle<cr>')
map('n', '<M-M>', '<cmd>NvimTreeFindFile<cr>') -- Locate file

-- Tabline binds
map('n', '<C-q>', function() require('bufdelete').bufdelete(0, true) end) -- ctrl+Quit to close current tab
map('n', 'g1', function() require('bufferline').go_to_buffer(1, true) end)
map('n', 'g2', function() require('bufferline').go_to_buffer(2, true) end)
map('n', 'g3', function() require('bufferline').go_to_buffer(3, true) end)
map('n', 'g4', function() require('bufferline').go_to_buffer(4, true) end)
map('n', 'g5', function() require('bufferline').go_to_buffer(5, true) end)
map('n', 'g6', function() require('bufferline').go_to_buffer(6, true) end)
map('n', 'g7', function() require('bufferline').go_to_buffer(7, true) end)
map('n', 'g8', function() require('bufferline').go_to_buffer(8, true) end)
map('n', 'g9', function() require('bufferline').go_to_buffer(9, true) end)
map('n', 'g0', function() require('bufferline').go_to_buffer(10, true) end)
-- Tab control, tmux binds are "outer" Alt+h/l and vim is "inner" Alt+j/k
map('n', '<M-j>', '<cmd>BufferLineCyclePrev<CR>') -- Alt+j to move to left
map('n', '<M-k>', '<cmd>BufferLineCycleNext<CR>') -- Alt+k to move to right
map('n', '<M-J>', '<cmd>BufferLineMovePrev<CR>') -- Alt+Shift+j grab to with you to left
map('n', '<M-K>', '<cmd>BufferLineMoveNext<CR>') -- Alt+Shift+k grab to with you to right

-- Tabpage binds
map('n', '<leader>1', '<cmd>tabnext1<cr>')
map('n', '<leader>2', '<cmd>tabnext2<cr>')
map('n', '<leader>3', '<cmd>tabnext3<cr>')
map('n', '<leader>4', '<cmd>tabnext4<cr>')
map('n', '<leader>5', '<cmd>tabnext5<cr>')
map('n', '<leader>6', '<cmd>tabnext6<cr>')
map('n', '<leader>7', '<cmd>tabnext7<cr>')
map('n', '<leader>8', '<cmd>tabnext8<cr>')
map('n', '<leader>9', '<cmd>tabnext9<cr>')
map('n', '<leader>0', '<cmd>tabnext10<cr>')

-----------------------------------
--          DEBUGGING            --
-----------------------------------
map('n', '<F5>', require'dap'.continue)
map('n', '<F6>', require'dap'.terminate)
map('n', '<F9>', require('persistent-breakpoints.api').toggle_breakpoint)
map('n', '<leader>cb', require('persistent-breakpoints.api').set_conditional_breakpoint)
map('n', '<leader>ccb', require('persistent-breakpoints.api').clear_all_breakpoints)
map('n', '<F10>', function() require'dap'.step_over() center_screen() end)
map('n', '<F11>', function() require'dap'.step_into() center_screen() end)
map('n', '<F12>', function() require'dap'.step_out() center_screen() end)

map('n', '<leader>rp', require'dap'.repl.open)

map('n', '<leader>db', require'dapui'.toggle)
map('n', '<leader>ev', require'dapui'.eval)

-----------------------------------
--         REFACTORING           --
-----------------------------------
map('v', '<leader>rf', '<Esc><cmd>lua require("telescope").extensions.refactoring.refactors()<CR>') -- open Refactor menu
map('n', '<leader>dp', function() require("refactoring").debug.printf({}) end) -- add Debug Print
map('v', '<leader>dp', function() require("refactoring").debug.print_var({}) end) -- add Debug Print
map('n', '<leader>dc', function() require("refactoring").debug.cleanup({}) end) -- Clean Debug prints

-----------------------------------
--           GOLANG              --
-----------------------------------
-- TODO: load only in go
map('n', '<leader>e', '<cmd>GoIfErr<cr>')
map('n', '<leader>dc', 'diw<Plug>(sandwich-delete)(') -- delete convertsion, e.g: int64(a) -> a
