-- lua/jasonli108/plugins/editor/mini.lua
return {
  {
    "nvim-mini/mini.nvim",
    version = "*",
    config = function()
      -- =========================
      -- Indentation guides
      -- =========================
      require("mini.indentscope").setup({
        draw = { animation = require("mini.indentscope").gen_animation.none() },
      })

      -- =========================
      -- Status column (folds, signs, number)
      -- =========================
      require("mini.statusline").setup({})

      -- =========================
      -- Autopairs for brackets, quotes, etc.
      -- =========================
      require("mini.pairs").setup({})

      -- =========================
      -- Surround motions (like vim-surround)
      -- =========================
      require("mini.surround").setup({
        mappings = {
          add = "sa",        -- Add surrounding in Normal and Visual modes
          delete = "sd",     -- Delete surrounding
          find = "sf",       -- Find surrounding to the right
          find_left = "sF",  -- Find surrounding to the left
          highlight = "sh",  -- Highlight surrounding
          replace = "sr",    -- Replace surrounding
          update_n_lines = "sn", -- Update number of lines for surroundings
        },
      })

      -- =========================
      -- Jumpable text objects
      -- =========================
      require("mini.jump").setup({})

      -- =========================
      -- Trailing spaces highlighting
      -- =========================
      require("mini.trailspace").setup({})
    end,
  },
}

