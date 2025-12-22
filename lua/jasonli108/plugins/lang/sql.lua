local sql_ft = { "sql", "mysql", "plsql" }

return {
  -- 1. Mason Tool Installer (sqlfluff)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "sqlfluff" })
    end,
  },

  -- 2. Database Core (tpope/vim-dadbod)
  {
    "tpope/vim-dadbod",
    cmd = "DB",
  },

  -- 3. Database UI
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = "vim-dadbod",
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    },
    init = function()
      local data_path = vim.fn.stdpath("data")
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true
      vim.g.db_ui_execute_on_save = false
    end,
  },

  -- 4. Autocompletion (Dadbod source)
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = "vim-dadbod",
    ft = sql_ft,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = sql_ft,
        callback = function()
          -- Buffer-local completion source injection
          require("cmp").setup.buffer({
            sources = { { name = "vim-dadbod-completion" } },
          })
        end,
      })
    end,
  },

  -- 5. Formatting: Conform
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.sqlfluff = {
        args = { "format", "--dialect=ansi", "-" },
      }
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(sql_ft) do
        opts.formatters_by_ft[ft] = { "sqlfluff" }
      end
    end,
  },

  -- 6. Linting: nvim-lint
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      for _, ft in ipairs(sql_ft) do
        opts.linters_by_ft[ft] = { "sqlfluff" }
      end
    end,
  },

  -- 7. Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "sql" })
    end,
  },

  -- 8. Edgy integration (Optional Window Management)
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Database",
        ft = "dbui",
        pinned = true,
        width = 0.3,
        open = function() vim.cmd("DBUI") end,
      })
      opts.bottom = opts.bottom or {}
      table.insert(opts.bottom, { title = "DB Query Result", ft = "dbout" })
    end,
  },
}

