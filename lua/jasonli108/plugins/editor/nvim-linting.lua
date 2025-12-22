return {
  "mfussenegger/nvim-lint",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      python = { "ruff" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      java = { "checkstyle" },
      fish = { "fish" },
      ["*"] = { "cspell" }, -- global fallback
      ["_"] = { "fallback" }, -- extra fallback
    },
    linters = {
      -- JS/TS linters
      eslint_d = {
        cmd = "eslint_d",
        args = { "--stdin", "--stdin-filename", "$FILENAME" },
        stdin = true,
      },

      -- Fallback spell checker
      cspell = {
        cmd = "cspell",
        args = { "lint", "$FILENAME" },
      },
    },
  },



  config = function(_, opts)
    local lint = require("lint")

    -- Merge linters
    for name, linter in pairs(opts.linters) do
      lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name] or {}, linter)
    end

    lint.linters_by_ft = opts.linters_by_ft

    local function safe_lint(names)
      local ok, _ = pcall(function()
        lint.try_lint(names)
      end)
      if not ok then
        vim.notify("Linting failed — check linter configuration", vim.log.levels.WARN)
      end
    end

    -- Debounce wrapper
    local function debounce(ms, fn)
      local timer = vim.uv.new_timer()
      return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
          timer:stop()
          vim.schedule_wrap(fn)(unpack(argv))
        end)
      end
    end

    local function lint_current()
      local names = lint._resolve_linter_by_ft(vim.bo.filetype) or {}
      if #names == 0 then
        names = vim.tbl_extend("force", names, lint.linters_by_ft["_"] or {})
      end
      names = vim.tbl_extend("force", names, lint.linters_by_ft["*"] or {})
      safe_lint(names)
    end

    -- Auto lint on save
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = debounce(100, lint_current),
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>lt", lint_current, { desc = "Trigger linting for current file" })
    vim.keymap.set("n", "<leader>ll", function() vim.diagnostic.setloclist() end,
      { desc = "Show all linting for current file" })
    vim.keymap.set("n", "<leader>ls", function() safe_lint({ "cspell" }) end,
      { desc = "Trigger spell check for current file" })
    vim.keymap.set("n", "<leader>lf", function() vim.diagnostic.open_float() end, { desc = "Diagnostic float window" })
  end,
}
