return {
  -- 1. Ensure Binaries are installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "svelte-language-server" })
    end,
  },

  -- 2. Treesitter Grammar
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "svelte" })
    end,
  },

  -- 3. LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Configure Svelte LSP
      opts.servers.svelte = {
        -- 2025: capabilities are handled natively by Neovim 0.10+
        -- so we remove the legacy didChangeWatchedFiles hack
      }

      -- Inject Svelte support into VTSLS (TypeScript LSP)
      -- This allows cross-file navigation between TS and Svelte components
      if opts.servers.vtsls then
        local svelte_plugin_path = vim.fn.stdpath("data") 
          .. "/mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin"

        opts.servers.vtsls.settings = opts.servers.vtsls.settings or {}
        opts.servers.vtsls.settings.vtsls = opts.servers.vtsls.settings.vtsls or {}
        opts.servers.vtsls.settings.vtsls.tsserver = opts.servers.vtsls.settings.vtsls.tsserver or {}
        
        -- Enable the Svelte TypeScript plugin inside VTSLS
        opts.servers.vtsls.settings.vtsls.tsserver.globalPlugins = {
          {
            name = "typescript-svelte-plugin",
            location = svelte_plugin_path,
            enableForWorkspaceTypeScriptVersions = true,
          },
        }
      end
    end,
  },

  -- 4. Formatting: Conform
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        svelte = { "prettier" },
      },
    },
  },
}

