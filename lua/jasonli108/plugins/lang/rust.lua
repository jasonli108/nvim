return {
  -- 1. Mason Tool Installer (Debugger & TOML LSP)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Note: rust-analyzer should generally be installed via rustup, not Mason
      vim.list_extend(opts.ensure_installed, { "codelldb", "taplo" })
    end,
  },

  -- 2. Treesitter Grammars
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "rust", "ron" })
    end,
  },

  -- 3. Rustaceanvim (LSP Orchestrator)
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- 2025 current version
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          -- Custom mappings specific to Rustaceanvim features
          vim.keymap.set("n", "<leader>cR", function() vim.cmd.RustLsp("codeAction") end, 
            { desc = "Code Action (Rust)", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp("debuggables") end, 
            { desc = "Rust Debuggables", buffer = bufnr })
          vim.keymap.set("n", "<leader>ce", function() vim.cmd.RustLsp("explainError") end, 
            { desc = "Explain Error", buffer = bufnr })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
            checkOnSave = { command = "clippy" }, -- Use clippy for linting on save
            procMacro = { enable = true },
          },
        },
      },
    },
    config = function(_, opts)
      -- In 2025, rustaceanvim uses vim.g.rustaceanvim for its config
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  -- 4. Taplo (TOML LSP) for Cargo.toml
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.taplo = {
        keys = {
          { "K", function()
            if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
              require("crates").show_popup()
            else
              vim.lsp.buf.hover()
            end
          end, desc = "Show Crate Documentation" },
        },
      }
    end,
  },

  -- 5. Cargo.toml Dependency Completion & Popups
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = { completion = { cmp = { enabled = true } } },
    config = function(_, opts)
      require("crates").setup(opts)
    end,
  },

  -- 6. Autocompletion: Crates Source
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "crates" })
    end,
  },

  -- 7. Neotest Integration
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = { adapters = { ["rustaceanvim.neotest"] = {} } },
  },
}

