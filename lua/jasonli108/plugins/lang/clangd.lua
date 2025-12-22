return {
  -- 1. Ensure Binaries are installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "clangd", "clang-format", "codelldb" })
    end,
  },

  -- 2. Treesitter Grammars
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "c", "cpp" })
    end,
  },

  -- 3. Clangd Extensions (Better AST, Inlay Hints)
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {
      inlay_hints = { inline = false },
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
      },
    },
  },

  -- 4. LSP: Clangd (Injected into main config)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.clangd = {
        keys = {
          { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
        },
        capabilities = {
          offsetEncoding = { "utf-16" }, -- Critical for clangd to avoid encoding warnings
        },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      }

      -- Custom setup to initialize clangd_extensions
      opts.setup = opts.setup or {}
      opts.setup.clangd = function(_, server_opts)
        require("clangd_extensions").setup({
          server = server_opts,
        })
        -- Returning false tells the main orchestrator to proceed with lspconfig[server].setup()
        return false
      end
    end,
  },

  -- 5. Autocompletion: Sorting with clangd_extensions
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sorting = opts.sorting or {}
      opts.sorting.comparators = opts.sorting.comparators or {}
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
    end,
  },

  -- 6. Debugging: CodeLLDB
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      -- Use stdpath to avoid registry nil-value errors in 2025
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
      
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = mason_path,
          args = { "--port", "${port}" },
        },
      }

      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
        }
      end
    end,
  },
}

