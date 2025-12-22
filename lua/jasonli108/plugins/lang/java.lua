local java_filetypes = { "java" }

return {
  -- 1. Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "java" })
    end,
  },

  -- 2. Mason Tool Installer (Debugger & Tester)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "jdtls", "java-debug-adapter", "java-test" })
    end,
  },

  -- 3. Prevent lspconfig from starting jdtls (nvim-jdtls will handle it)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { jdtls = {} },
      setup = {
        jdtls = function()
          return true -- This is mandatory to prevent double-start
        end,
      },
    },
  },

  -- 4. Main nvim-jdtls Logic
  {
    "mfussenegger/nvim-jdtls",
    ft = java_filetypes,
    opts = function()
      -- Use stdpath for robust path construction in 2025
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
      local lombok_jar = mason_path .. "/jdtls/lombok.jar"
      
      return {
        root_dir = require("jdtls.setup").find_root({ "pom.xml", "gradle.build", ".git" }),
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,
        cmd = {
          "jdtls",
          string.format("--jvm-arg=-javaagent:%s", lombok_jar),
        },
        settings = {
          java = {
            inlayHints = { parameterNames = { enabled = "all" } },
          },
        },
      }
    end,
    config = function(_, opts)
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
      local bundles = {}

      -- Robust Bundle Loading (Debug & Test)
      local debug_pkg = mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
      local test_pkg = mason_path .. "/java-test/extension/server/*.jar"
      
      vim.list_extend(bundles, vim.fn.glob(debug_pkg, true, true))
      vim.list_extend(bundles, vim.fn.glob(test_pkg, true, true))

      local function attach_jdtls()
        local root_dir = opts.root_dir
        local project_name = opts.project_name(root_dir)
        
        local config = {
          cmd = vim.deepcopy(opts.cmd),
          root_dir = root_dir,
          init_options = { bundles = bundles },
          settings = opts.settings,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        }

        if project_name then
          vim.list_extend(config.cmd, {
            "-configuration", opts.jdtls_config_dir(project_name),
            "-data", opts.jdtls_workspace_dir(project_name),
          })
        end

        require("jdtls").start_or_attach(config)
      end

      -- Attach on FileType
      vim.api.nvim_create_autocmd("FileType", {
        pattern = java_filetypes,
        callback = attach_jdtls,
      })
      
      -- Initial attach for the first buffer opened
      attach_jdtls()
    end,
  },
}

