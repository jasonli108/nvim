return {
  -- 1. Ensure Binaries are installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "angular-language-server" })
    end,
  },

  -- 2. Treesitter Grammars (Angular & SCSS)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "angular", "scss" })
      
      -- Native auto-command for Angular templates
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*.component.html", "*.container.html" },
        callback = function()
          vim.treesitter.start(nil, "angular")
        end,
      })
    end,
  },

  -- 3. LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Configure AngularLS
      opts.servers.angularls = {}

      -- HACK: Avoid duplicate rename popups in Angular
      opts.setup = opts.setup or {}
      opts.setup.angularls = function(_, server_opts)
        server_opts.on_attach = function(client)
          client.server_capabilities.renameProvider = false
        end
        return false
      end

      -- Inject Angular plugin into VTSLS (TypeScript LSP)
      -- This allows cross-file navigation between TS and HTML templates
      if opts.servers.vtsls then
        local angular_path = vim.fn.stdpath("data") .. "/mason/packages/angular-language-server/node_modules/@angular/language-server"
        
        opts.servers.vtsls.settings = opts.servers.vtsls.settings or {}
        opts.servers.vtsls.settings.vtsls = opts.servers.vtsls.settings.vtsls or {}
        opts.servers.vtsls.settings.vtsls.tsserver = opts.servers.vtsls.settings.vtsls.tsserver or {}
        
        opts.servers.vtsls.settings.vtsls.tsserver.globalPlugins = {
          {
            name = "@angular/language-server",
            location = angular_path,
            enableForWorkspaceTypeScriptVersions = false,
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
        html = { "prettier" },
        angular = { "prettier" },
      },
    },
  },
}

