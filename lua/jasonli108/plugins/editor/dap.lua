-- Debugging Support
return {
  -- https://github.com/rcarriga/nvim-dap-ui
  'rcarriga/nvim-dap-ui',
  event = 'VeryLazy',
  dependencies = {
    -- https://github.com/mfussenegger/nvim-dap
    'mfussenegger/nvim-dap',
    -- https://github.com/nvim-neotest/nvim-nio
    'nvim-neotest/nvim-nio',
    -- https://github.com/theHamsta/nvim-dap-virtual-text
    'theHamsta/nvim-dap-virtual-text', -- inline variable text while debugging
    -- https://github.com/nvim-telescope/telescope-dap.nvim
    'nvim-telescope/telescope-dap.nvim', -- telescope integration with dap
  },
  opts = {
    controls = {
      element = "repl",
      enabled = false,
      icons = {
        disconnect = "",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = ""
      }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" }
      }
    },
    force_buffers = true,
    icons = {
      collapsed = "",
      current_frame = "",
      expanded = ""
    },
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.50
          },
          {
            id = "stacks",
            size = 0.30
          },
          {
            id = "watches",
            size = 0.10
          },
          {
            id = "breakpoints",
            size = 0.10
          }
        },
        size = 40,
        position = "left", -- Can be "left" or "right"
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 10,
        position = "bottom", -- Can be "bottom" or "top"
      }
    },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t"
    },
    render = {
      indent = 1,
      max_value_lines = 100
    }
  },
  config = function (_, opts)
    local dap = require('dap')
    require('dapui').setup(opts)

    -- Customize breakpoint signs
    vim.api.nvim_set_hl(0, "DapStoppedHl", { fg = "#98BB6C", bg = "#2A2A2A", bold = true })
    vim.api.nvim_set_hl(0, "DapStoppedLineHl", { bg = "#204028", bold = true })
    vim.fn.sign_define('DapStopped', { text='', texthl='DapStoppedHl', linehl='DapStoppedLineHl', numhl= '' })
    vim.fn.sign_define('DapBreakpoint', { text='', texthl='DiagnosticSignError', linehl='', numhl='' })
    vim.fn.sign_define('DapBreakpointCondition', { text='', texthl='DiagnosticSignWarn', linehl='', numhl='' })
    vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DiagnosticSignError', linehl='', numhl= '' })
    vim.fn.sign_define('DapLogPoint', { text='', texthl='DiagnosticSignInfo', linehl='', numhl= '' })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      require('dapui').open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      -- Commented to prevent DAP UI from closing when unit tests finish
      -- require('dapui').close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      -- Commented to prevent DAP UI from closing when unit tests finish
      -- require('dapui').close()
    end

    -- Add dap configurations based on your language/adapter settings

      -- =====================================================
      -- Python Adapter
      -- =====================================================
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"),
        args = { "-m", "debugpy.adapter" },
      }

      local function get_python_path()
        local cwd = vim.loop.cwd()
        if vim.env.VIRTUAL_ENV then return vim.env.VIRTUAL_ENV .. "/bin/python" end
        for _, venv in ipairs({ ".venv", "venv", "env" }) do
          local python = cwd .. "/" .. venv .. "/bin/python"
          if vim.fn.executable(python) == 1 then return python end
        end
        return vim.fn.exepath("python3") or vim.fn.exepath("python")
      end

      local function get_args(config)
        local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
        local args_str = type(args) == "table" and table.concat(args, " ") or args
        config = vim.deepcopy(config)
        config.args = function()
          local input = vim.fn.expand(vim.fn.input("Run with args: ", args_str))
          return require("dap.utils").splitstr(input)
        end
        return config
      end

      dap.configurations.python = {
        {
          name = "Launch file",
          type = "python",
          request = "launch",
          program = "${file}",
          pythonPath = get_python_path(),
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          justMyCode = true,
        },
        get_args({
          name = "Launch with args",
          type = "python",
          request = "launch",
          program = "${file}",
          pythonPath = get_python_path(),
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        }),
        {
          name = "Pytest: Current file",
          type = "python",
          request = "launch",
          module = "pytest",
          args = { "${file}" },
          pythonPath = get_python_path(),
          console = "integratedTerminal",
          justMyCode = true,
        },
      }
  end,

    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Evaluate" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAPUI" },
      {
        "<leader>dq",
        function()
          require("dap").terminate()
          require("dapui").close()
        end,
        desc = "Terminate Debugging and Close UI",
      },
      {
        "<leader>drs",
        function()
          local dap = require("dap")
          local dapui = require("dapui")
          dap.terminate()
          dapui.close()
          dap.continue()
        end,
        desc = "Restart Debugging Session",
      },
    },
}


