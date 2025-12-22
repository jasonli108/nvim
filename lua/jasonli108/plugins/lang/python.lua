local lsp_servers = {
  python_ls = "pyright",
  python_linter = "ruff",
}

return {
  -- 1. Ensure all binaries are installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        lsp_servers.python_ls,
        lsp_servers.python_linter,
        "black", "debugpy", "mypy"
      })
    end,
  },

  -- 2. Inject settings into main LSP config
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers[lsp_servers.python_ls] = {
        settings = { python = { analysis = { autoSearchPaths = true } } },
      }
      opts.servers[lsp_servers.python_linter] = {
        init_options = { settings = { logLevel = "error" } },
      }
    end,
  },

  -- 3. Robust DAP setup (Fixes the nil error)
  {
    "mfussenegger/nvim-dap",
    dependencies = { "mfussenegger/nvim-dap-python" },
    config = function()
      -- Directly construct the path to avoid registry race conditions
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy"
      local platform = vim.loop.os_uname().sysname
      
      -- Set path based on OS (Windows uses Scripts/python.exe)
      local python_path = platform == "Windows_NT" 
        and mason_path .. "/venv/Scripts/python.exe"
        or mason_path .. "/venv/bin/python"

      require("dap-python").setup(python_path)
    end,
  },

  -- 4. Formatting
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { python = { "black" } } },
  },

  -- 5. VirtualEnv Selection
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp", 
    cmd = "VenvSelect",
    opts = { settings = { options = { notify_user_on_venv_activation = true } } },
    keys = { { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" } },
  },

  -- 6. Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "python", "ninja", "rst" })
    end,
  },
}

