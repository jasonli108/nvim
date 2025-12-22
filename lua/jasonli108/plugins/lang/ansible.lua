return {
  -- 1. Ensure Binaries are installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ansible-language-server", "ansible-lint" })
    end,
  },

  -- 2. Treesitter Grammars
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "yaml" })
    end,
  },

  -- 3. Inject ansiblels into the main LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.ansiblels = {
        settings = {
          ansible = {
            ansible = { path = "ansible" },
            executionEnvironment = { enabled = false },
            python = { interpreterPath = "python3" },
            validation = {
              enabled = true,
              lint = { enabled = true, path = "ansible-lint" },
            },
          },
        },
      }
    end,
  },

  -- 4. Formatting: Conform
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ansible = { "prettier" },
      },
    },
  },

  -- 5. Ansible Run Helper
  {
    "mfussenegger/nvim-ansible",
    keys = {
      {
        "<leader>ta",
        function()
          require("ansible").run()
        end,
        desc = "Ansible Run Playbook/Role",
      },
    },
  },
}

