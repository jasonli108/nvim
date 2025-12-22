return {
  -- 1. Treesitter Grammars
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "terraform", "hcl" })
    end,
  },

  -- 2. Mason Tool Installer (Binaries)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "terraform-ls", "tflint" })
    end,
  },

  -- 3. LSP: Terraform-ls (Injected into main config)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.terraformls = {}
    end,
  },

  -- 4. Formatting: Conform
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
      },
    },
  },

  -- 5. Linting: nvim-lint
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        terraform = { "tflint" },
        tf = { "tflint" },
      },
    },
  },

  -- 6. Telescope Extensions (Documentation and Resources)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "ANGkeith/telescope-terraform-doc.nvim",
      "cappyzawa/telescope-terraform.nvim",
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- Load extensions directly
      telescope.load_extension("terraform_doc")
      telescope.load_extension("terraform")
    end,
  },
}

