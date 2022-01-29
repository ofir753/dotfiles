-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- https://github.com/wbthomason/packer.nvim

-- Recommended Plugins: https://github.com/rockerBOO/awesome-neovim

local cmd = vim.cmd
cmd [[packadd packer.nvim]]

cmd("let g:XkbSwitchLib = '/usr/local/lib/libg3kbswitch.so'")
cmd("let g:XkbSwitchEnabled = 1")

-- TODO: Fix dependencies

return require('packer').startup(function()
	use 'wbthomason/packer.nvim' -- packer can manage itself

	-------- LSP --------
	use 'neovim/nvim-lspconfig'

	-- Complete engine
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use 'dcampos/nvim-snippy'
	use 'dcampos/cmp-snippy'
	use 'f3fora/cmp-spell'

	use 'honza/vim-snippets' -- Default snippets
	use 'tami5/lspsaga.nvim' -- Sweet ui for rename + code action and hover doc
	use 'RRethy/vim-illuminate' -- Mark word on cursor
	use 'ray-x/lsp_signature.nvim' -- Signature hint while typing
	use 'onsails/lspkind-nvim' -- Adding sweet ui for kind (function/var/method)
	use 'nvim-lua/lsp-status.nvim' -- Lsp Status in statusline

	-- TreeSitter
	use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
	use 'nvim-treesitter/playground' -- TreeSitter helper to customize
	use 'tanvirtin/monokai.nvim' -- Color theme (customized)
	use {
		'SmiteshP/nvim-gps', -- Shows context in status line
		requires = 'nvim-treesitter/nvim-treesitter'
	}

	use 'lukas-reineke/indent-blankline.nvim' -- Indent line helper
	use 'numToStr/Comment.nvim' -- Comments
	use 'nvim-treesitter/nvim-treesitter-textobjects' -- Movements base on treesitter

	-- Telescope
	use 'nvim-lua/plenary.nvim' -- Required by telescope and more
	use 'nvim-telescope/telescope.nvim' -- Fuzzy finder with alot of integration
	use 'nvim-telescope/telescope-file-browser.nvim' -- The file browser
	use 'nvim-telescope/telescope-live-grep-raw.nvim' -- Better live grep

	-- Status Line
	use 'nvim-lualine/lualine.nvim' -- Status line
	use 'kyazdani42/nvim-web-devicons' -- Web icons (more plugins using this)

	-- Git
	use 'lewis6991/gitsigns.nvim' -- Show git diff in the sidebar, hunk actions and more
	use 'tpope/vim-fugitive' -- Git cli inside nvim with extra tools :Git
	-- TODO: Get more git feature (merge diff and stuff like this)

	-- Misc
	use 'tpope/vim-repeat' -- Extending repeat (.) action
	use 'ggandor/lightspeed.nvim' -- Lightspeed motions (s, S) -- TODO: need to learn more about that https://github.com/ggandor/lightspeed.nvim
	use 'machakann/vim-sandwich' -- Sandwich text (sa action)
	use 'lambdalisue/suda.vim' -- Sudo write/read (SudaWrite/Read)
	use 'jdhao/better-escape.vim' -- Escape insert mode fast (jk)
	use 'windwp/nvim-autopairs' -- Closes (--' etc.
	use 'ellisonleao/glow.nvim' -- Markdown preview
	use 'ntpeters/vim-better-whitespace' -- Whitespace trailing
	use 'Pocco81/AutoSave.nvim' -- Auto save
	use 'romgrk/barbar.nvim' -- Tabline
	use 'xolox/vim-session' -- Session Manager
	use 'xolox/vim-misc' -- For vim-session
	use 'ethanholz/nvim-lastplace' -- Save last place
	use 'mg979/vim-visual-multi' -- Multi cursors
	use 'mizlan/iswap.nvim' -- Swap arguments, elements
	use 'christoomey/vim-tmux-navigator' -- Navigate in panes integrated to vim
	use 'rhysd/devdocs.vim' -- Open DevDocs from nvim
	use 'lyokha/vim-xkbswitch' -- Switch to english for normal mode
	use { 'michaelb/sniprun', run = 'bash ./install.sh'} -- Run snippets in your code
	use {
		'AckslD/nvim-revJ.lua', -- Reverse join (split)
		requires = {'kana/vim-textobj-user', 'sgur/vim-textobj-parameter'},
	}
	use 'nacro90/numb.nvim' -- Peek at line number before jump
	use {
		"danymat/neogen", -- Doc generator
		requires = "nvim-treesitter/nvim-treesitter"
	}
	use {
		'kyazdani42/nvim-tree.lua', -- File Tree
		requires = {
			'kyazdani42/nvim-web-devicons',
		},
	}
	use "jbyuki/venn.nvim" -- Draw ascii boxes and arrows, start the mode with :Draw, exit with escape, HJKL for arrows, f for box (inside <C-v>)

	-- Improvment Games
	use 'ThePrimeagen/vim-be-good'


end)
