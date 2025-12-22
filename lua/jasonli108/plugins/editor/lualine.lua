-- Status line
return {
  -- :contentReference[oaicite:0]{index=0}
  "nvim-lualine/lualine.nvim",
  dependencies = {
    -- :contentReference[oaicite:1]{index=1}
    "nvim-tree/nvim-web-devicons",
    -- :contentReference[oaicite:2]{index=2}
    "linrongbin16/lsp-progress.nvim",
  },

  opts = {
    options = {
      theme = "codedark",
      globalstatus = true,
      disabled_filetypes = {
        statusline = { "neo-tree" },
        winbar = { "neo-tree" },
      },
    },

    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },

      lualine_c = {
        {
          "filename",
          file_status = true,
          newfile_status = false,

          -- 4 = parent/filename
          path = 4,

          symbols = {
            modified = "[+]",
            readonly = "[-]",
            unnamed = "", -- 🔑 hide [No Name]
          },

          -- 🔑 suppress display entirely for empty buffers
          cond = function()
            return vim.fn.bufname() ~= ""
          end,
        },
      },

      lualine_x = {
        {
          function()
            return require("lsp-progress").progress()
          end,
          cond = function()
            return package.loaded["lsp-progress"]
          end,
        },
        "encoding",
        "filetype",
      },

      lualine_y = { "progress" },
      lualine_z = { "location" },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}

