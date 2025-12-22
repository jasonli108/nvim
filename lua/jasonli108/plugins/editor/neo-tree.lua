return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim", -- required by neo-tree
  },


	deactivate = function()
		vim.cmd("Neotree close")
	end,

  opts={

    window = {
      close_if_last_window = true,
      open_file = {
        quit_on_open = true,  -- close neo-tree when opening a file
        resize_window = true,
        use_last_window = false, -- open the file in the main window
      },
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
          desc = "Copy Path to Clipboard",
        },
        ["P"] = { "toggle_preview", config = { use_float = false } },
      },
    },


  },

  config = function(_, opts)
    require("neo-tree").setup(opts)
  end,

}

