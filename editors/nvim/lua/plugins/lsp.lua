-- neovim/nvim-lspconfig
if vim.g.started_by_firenvim then
	do return end
end

local lspconfig = require('lspconfig')

-- Update capabilities to autocomplete
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp_signature_cfg = {
	bind = true,
	use_lspsaga = false,
	doc_lines = 0,
	floating_window = false,
	hint_scheme = 'LspSignatureHintVirtualText',
	hint_prefix = ' ',
}

local lsp_on_attach = function(client, bufnr)
	-- ray-x/lsp_signature.nvim
	require('lsp_signature').on_attach(lsp_signature_cfg)
	-- SmiteshP/nvim-navic
	require('nvim-navic').attach(client, bufnr)
end

if not NO_SUDO then
	lspconfig.pyright.setup {
		on_attach = lsp_on_attach,
		capabilities = capabilities,
	}
else
	lspconfig.pylsp.setup {
		on_attach = lsp_on_attach,
		capabilities = capabilities,
		settings = {
			pylsp = {
				plugins = {
					pycodestyle = {
						enabled = false
					}
				}
			}
		},
	}
end

lspconfig.rust_analyzer.setup {
	on_attach = lsp_on_attach,
	capabilities = capabilities,
	settings = {
		['rust-analyzer'] = {
			-- enable clippy on save
			checkOnSave = {
				command = 'clippy'
			},
		}
	},
}

-- simrat39/rust-tools.nvim
require('rust-tools').setup {
	server = nil, -- Skip rust-tools lsp setup
	dap = nil, -- Skip rust-tools dap setup
	tools = {
		inlay_hints = {
			auto = false,
		},
		hover_actions = {
			auto_focus = true,
		},
	}
}

-- Saecki/crates.nvim
require('crates').setup {
}

lspconfig.bashls.setup {
	on_attach = lsp_on_attach,
	capabilities = capabilities,
}
lspconfig.vimls.setup {
	on_attach = lsp_on_attach,
	capabilities = capabilities,
}
lspconfig.cmake.setup {
	on_attach = lsp_on_attach,
	capabilities = capabilities,
}
lspconfig.gopls.setup {
	on_attach = lsp_on_attach,
	capabilities = capabilities,
	settings = {
		gopls = {
			usePlaceholders = true
		}
	}
}
lspconfig.cucumber_language_server.setup {
	on_attach = lsp_on_attach,
	capabilities = capabilities,
}
lspconfig.tsserver.setup {
	on_attach = lsp_on_attach,
	capabilities = capabilities,
}

local clang_cmd = { 'clangd', '--background-index', '--fallback-style=none', '--header-insertion=never',
	'--all-scopes-completion', '--cross-file-rename' }

if vim.fn.has('wsl') == 1 then
	table.insert(clang_cmd, '-j=4') -- Limit resources on wsl
end

if NO_SUDO then
	clang_cmd = { 'clangd', '-completion-style=bundled' }
end

lspconfig.clangd.setup {
	init_options = {
		clangdFileStatus = true
	},
	on_attach = lsp_on_attach,
	capabilities = capabilities,
	cmd = clang_cmd,
}

-- folke/neodev.nvim
require('neodev').setup {
}

lspconfig.sumneko_lua.setup {
	on_attach = lsp_on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			telemetry = {
				enable = false,
			},
		},
	},
}

-- j-hui/fidget.nvim
require('fidget').setup {
}

-- ofirgall/format-on-leave.nvim
require('format-on-leave').setup {
	pattern = { '*.rs', '*.go' }
}

local path = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
local words = {}

for word in io.open(path, "r"):lines() do
	table.insert(words, word)
end

lspconfig.ltex.setup {
	filetypes = { 'bib', 'markdown', 'org', 'plaintex', 'rst', 'rnoweb', 'tex' },
	settings = {
		ltex = {
			dictionary = {
				['en-US'] = words,
			},
		},
	},
}

-- RRethy/vim-illuminate
require('illuminate').configure {
	modes_denylist = { 'i' },
}

