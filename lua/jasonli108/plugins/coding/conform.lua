return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        java = { "google-java-format" }, -- Use the standard name or your custom key
        python = { "black" },            -- Added python since you defined black below
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
      formatters = {
        -- Overriding the built-in google-java-format or defining a custom one
        ["google-java-format"] = {
          prepend_args = { "--aosp" },
        },
        black = {
          prepend_args = { "--line-length", "100" },
        },
      },
      format_on_save = {
        async = false,
        lsp_fallback = true,
        timeout_ms = 8000,
      },
    })

    -- Keymap for Conform formatting (handles both buffer and visual range)
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 8000,
      })
    end, { desc = "Format file or range (in visual mode)" })

    -- Standard LSP-only formatting fallback
    vim.keymap.set({ "n", "v" }, "<leader>mf", function()
      vim.lsp.buf.format({ async = true })
    end, { noremap = true, silent = true, desc = "LSP native format" })
  end,
}

