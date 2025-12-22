return {
  -- 1. SchemaStore Support
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },

  -- 2. Inject YAML settings into your main nvim-lspconfig opts
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure servers table exists
      opts.servers = opts.servers or {}

      -- Configure yamlls
      opts.servers.yamlls = {
        -- Pass capabilities needed for line folding
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
        -- Lazy-load SchemaStore on new configurations
        on_new_config = function(new_config)
          new_config.settings.yaml.schemas = vim.tbl_deep_extend(
            "force",
            new_config.settings.yaml.schemas or {},
            require("schemastore").yaml.schemas()
          )
        end,
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            keyOrdering = false,
            format = { enable = true },
            validate = true,
            schemaStore = {
              enable = false, -- Use SchemaStore.nvim instead of built-in
              url = "",
            },
          },
        },
      }

      -- Handle the 0.10 formatting provider fix in the setup table
      -- This corresponds to the 'setup' logic in the original LazyVim file
      opts.setup = opts.setup or {}
      opts.setup.yamlls = function(_, server_opts)
        -- If on Neovim < 0.10, manually enable formatting
        if vim.fn.has("nvim-0.10") == 0 then
          server_opts.on_attach = function(client, _)
            client.server_capabilities.documentFormattingProvider = true
          end
        end
        -- Returning false ensures your main init.lua continues with standard setup
        return false 
      end
    end,
  },

  -- 3. Mason Tool Installer (Optional but recommended for consistency)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "yamlls" })
    end,
  },
}

