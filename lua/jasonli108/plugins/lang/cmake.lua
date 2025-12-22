return {
  -- 1. Treesitter Grammar
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "cmake" })
    end,
  },

  -- 2. Mason Tool Installer (LSP, Formatter, Linter)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "neocmake", "cmakelang", "cmakelint" })
    end,
  },

  -- 3. Inject neocmake into the main LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.neocmake = {}
    end,
  },

  -- 4. Formatting: Conform (using cmakelang/gersemi)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cmake = { "cmake_format" },
      },
    },
  },

  -- 5. Linting: nvim-lint
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        cmake = { "cmakelint" },
      },
    },
  },

  -- 6. CMake Tools (Project Management)
  {
    "Civitasv/cmake-tools.nvim",
    ft = "cmake", -- Lazy load by filetype instead of manual DirChanged logic
    opts = {
      cmake_command = "cmake",
      cmake_build_directory = "build",
      cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
    },
  },
}

