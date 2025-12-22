return {
  -- 1. Treesitter Grammars for Git
  -- We use spec merging to add these to your existing TS config
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 
        "git_config", 
        "gitcommit", 
        "git_rebase", 
        "gitignore", 
        "gitattributes" 
      })
    end,
  },

  -- 2. Git Completion for nvim-cmp
  -- Adds the ability to complete GitHub issues, PRs, and commits
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "petertriho/cmp-git", opts = {} },
    },
    opts = function(_, opts)
      -- Ensure sources table exists
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "git" })
    end,
  },

  -- 3. LSP: Git-related language servers (Optional but recommended in 2025)
  -- For example, gitlint or similar tools if you want diagnostic support
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      -- You can add 'gitlint' here if you manage it via Mason
    end,
  },

  -- 4. Linting/Formatting (Standard 2025 approach)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        gitcommit = { "gitlint" },
      },
    },
  },
}

