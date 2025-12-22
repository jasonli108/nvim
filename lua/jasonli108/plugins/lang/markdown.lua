-- 1. Setup Filetype Detection (Replaces LazyVim.on_very_lazy)
vim.filetype.add({
  extension = { mdx = "markdown.mdx" },
})

return {
  -- 2. Mason Tool Installer (Binaries)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "marksman", "markdownlint-cli2", "markdown-toc", "prettier", "cspell" })
    end,
  },

  -- 3. LSP: Marksman (Injected into main config)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.marksman = {} -- Basic setup, handled by main init.lua
    end,
  },

  -- 4. Formatting: Conform
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then return true end
            end
          end,
        },
      },
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },

  -- 5. Linting: nvim-lint
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
    },
  },

  -- 6. Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install", -- Standard 2025 build command
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    keys = {
      { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview", ft = "markdown" },
    },
  },

  -- 7. Render-Markdown (Improved UI)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "markdown.mdx", "norg", "rmd", "org" },
    opts = {
      code = { sign = false, width = "block", right_pad = 1 },
      heading = { sign = false, icons = {} },
    },
    keys = {
      {
        "<leader>um",
        function()
          local m = require("render-markdown")
          if require("render-markdown.state").enabled then
            m.disable()
          else
            m.enable()
          end
        end,
        desc = "Toggle Render Markdown",
      },
    },
  },
}

