return {
  -- 1. Ensure Binaries are installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Mason package name is still vue-language-server
      vim.list_extend(opts.ensure_installed, { "vue-language-server" })
      return opts
    end,
  },

  -- 2. Treesitter Grammars
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Added 'html' as it is essential for Vue templates
      vim.list_extend(opts.ensure_installed, { "vue", "css", "scss", "html" })
      return opts
    end,
  },

  -- 3. LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- FIXED: Changed 'volar' to 'vue_ls' to resolve deprecation
      opts.servers.vue_ls = {
        init_options = {
          vue = {
            -- 2025 standard: hybridMode handles templates only, 
            -- letting vtsls handle the script part
            hybridMode = true,
          },
        },
      }

      -- Inject Vue support into VTSLS (TypeScript LSP)
      if opts.servers.vtsls then
        -- Initialize nested tables safely
        opts.servers.vtsls.filetypes = opts.servers.vtsls.filetypes or {}
        if not vim.tbl_contains(opts.servers.vtsls.filetypes, "vue") then
          table.insert(opts.servers.vtsls.filetypes, "vue")
        end

        -- Path to the TypeScript plugin inside the Vue Language Server package
        local vue_plugin_path = vim.fn.stdpath("data") 
          .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

        opts.servers.vtsls.settings = opts.servers.vtsls.settings or {}
        opts.servers.vtsls.settings.vtsls = opts.servers.vtsls.settings.vtsls or {}
        opts.servers.vtsls.settings.vtsls.tsserver = opts.servers.vtsls.settings.vtsls.tsserver or {}
        
        -- Enable the Vue TypeScript plugin inside VTSLS
        opts.servers.vtsls.settings.vtsls.tsserver.globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_plugin_path,
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        }
      end
      return opts
    end,
  },

  -- 4. Formatting: Conform (Prettier for Vue)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.vue = { "prettier" }
      return opts
    end,
  },
}

