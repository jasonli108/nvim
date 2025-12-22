return {
  -- 1. Ensure Binaries are installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tailwindcss-language-server" })
    end,
  },

  -- 2. Inject Tailwind into the main LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.tailwindcss = {
        -- Define filetypes explicitly (Standard 2025 list)
        filetypes = {
          "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure",
          "django-html", "htmldjango", "edge", "eelixir", "elixir",
          "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml",
          "handlebars", "hbs", "html", "html-eex", "heex", "jade",
          "leaf", "liquid", "markdown", "mdx", "mustache", "njk",
          "nunjucks", "php", "razor", "slim", "twig", "css", "less",
          "postcss", "sass", "scss", "stylus", "sugarss", "javascript",
          "javascriptreact", "reason", "rescript", "typescript",
          "typescriptreact", "vue", "svelte", "templ",
        },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              elixir = "html-eex",
              eelixir = "html-eex",
              heex = "html-eex",
            },
            -- 2025: Enable class sorting and linting
            validate = true,
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidScreen = "error",
              invalidVariant = "error",
              invalidConfigPath = "error",
              showPixelValues = true,
            },
          },
        },
      }
    end,
  },
  -- 3. Autocompletion: Color Previews
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
    },
    opts = function(_, opts)
      -- 1. Create the formatting table if it doesn't exist yet
      opts.formatting = opts.formatting or {}
      
      -- 2. Store the existing format function (if any) to preserve icons
      local format_kinds = opts.formatting.format
      
      -- 3. Set the new format function
      opts.formatting.format = function(entry, item)
        -- Run the previous formatter logic first (e.g., lspkind icons)
        if format_kinds then
          item = format_kinds(entry, item)
        end
        -- Add the tailwind color square
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },

}

