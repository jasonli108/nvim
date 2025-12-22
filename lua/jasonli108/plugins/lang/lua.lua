local lsp_server = "lua_ls"

return {
  -- 1. Tools (Mason)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "stylua", "shfmt", lsp_server })
    end,
  },

  -- 2. LSP Settings (The LazyVim way)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      
      -- Inject settings for lua_ls into the central opts table
      opts.servers[lsp_server] = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { 
              library = vim.api.nvim_get_runtime_file("", true), 
              checkThirdParty = false 
            },
            telemetry = { enable = false },
            hint = { enable = true }, -- 2025: Enable inlay hints for Lua
          },
        },
      }
    end,
  },

  -- 3. Formatter
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.lua = { "stylua" }
    end,
  },

  -- 4. Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "lua", "luadoc", "luap" })
    end,
  },
}

