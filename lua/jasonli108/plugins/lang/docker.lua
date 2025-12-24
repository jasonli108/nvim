return {
  -- 1. Treesitter Grammars for Docker & Compose
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "dockerfile", "yaml" })
      return opts
    end,
  },

  -- 2. Mason Tool Installer (LSPs and Linters)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 
        "dockerls", 
        "docker-compose-language-service", 
        "hadolint" 
      })
      return opts
    end,
  },

  -- 3. Inject LSPs into the main config
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      
      -- Standard Dockerfile LSP
      opts.servers.dockerls = {}
      
      -- Docker Compose LSP (Handles compose.yaml and docker-compose.yaml)
      opts.servers.docker_compose_language_service = {}
      return opts
    end,
  },

  -- 4. Linting: nvim-lint (Hadolint)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },

  -- 5. Formatting: Conform
  -- Dockerfiles are typically formatted by dockerls, but you can add custom formatters here
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        dockerfile = { "trim_whitespace" },
      },
    },
  },
}

