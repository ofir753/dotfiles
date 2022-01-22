-----------------------------------------------------------
-- Tree Sitter
-----------------------------------------------------------

-- https://github.com/

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  sync_install = false,
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
	custom_captures = {
	}
  },
  -- TODO: different file, smart loop for bindings
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["gj"] = "@function.outer",
        ["]]"] = "@class.outer",
        ["]b"] = "@block.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["gJ"] = "@function.outer",
        ["]["] = "@class.outer",
        ["]B"] = "@block.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["gk"] = "@function.outer",
        ["[["] = "@class.outer",
        ["[b"] = "@block.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["gK"] = "@function.outer",
        ["[]"] = "@class.outer",
        ["[B"] = "@block.outer",
      },
    },
  },
}

require("nvim-gps").setup()