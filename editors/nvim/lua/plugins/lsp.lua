if vim.g.started_by_firenvim then
	do return end
end

-- neovim/nvim-lspconfig
local lspconfig = require('lspconfig')


-- ofirgall/format-on-leave.nvim
require('format-on-leave').setup {
	pattern = { '*.go', '*.rs', '*.lua' },
}


-- RRethy/vim-illuminate
require('illuminate').configure {
	modes_denylist = { 'i' },
}

require('lsp_lines').setup {
}

-- ray-x/go.nvim
require('go').setup {
}

-- simrat39/symbols-outline.nvim
require('symbols-outline').setup {
	show_numbers = true,
	show_relative_numbers = true,
	keymaps = {
		goto_location = 'o',
		focus_location = '<Cr>',
	},
}

-- SmiteshP/nvim-navbuddy
require('nvim-navbuddy').setup {
	lsp = {
		auto_attach = true,
	},
}
