-- lua/jasonli108/plugins/lsp/init.lua
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  opts = {
    servers = {}, -- This will be populated by your lang files
  },
  config = function(_, opts)
    -- 1. Setup Mason
    require("mason").setup()
    
    -- 2. Build the list of servers to install
    local ensure_installed = {}
    for server, server_opts in pairs(opts.servers) do
      if server_opts.mason ~= false then
        table.insert(ensure_installed, server)
      end
    end

    -- 3. Mason-lspconfig ensures binaries are there
    require("mason-lspconfig").setup({ ensure_installed = ensure_installed })

    -- 4. NEW 2025 NATIVE SETUP (Fixes the deprecation)
    for server, server_opts in pairs(opts.servers) do
      -- Define the configuration using the new native API
      -- This replaces require('lspconfig')[server].setup()
      vim.lsp.config(server, {
        install = true, -- Optional: helps with automatic installation
        cmd = server_opts.cmd,
        filetypes = server_opts.filetypes,
        settings = server_opts.settings,
        root_markers = server_opts.root_dir,
      })

      -- Enable the server
      vim.lsp.enable(server)
    end
  end,
}

