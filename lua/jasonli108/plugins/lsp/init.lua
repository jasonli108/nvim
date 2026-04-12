-- lua/jasonli108/plugins/lsp/init.lua
return {
	-- Keep lspconfig for its server settings data, but we'll use native APIs for setup
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

		-- 4. Native Neovim 0.11+ Setup
		for server, server_opts in pairs(opts.servers) do
			if server_opts.enabled ~= false then
				local capabilities = vim.lsp.protocol.make_client_capabilities()

				-- Add completion capabilities if available
				local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
				if ok_cmp then
					capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
				end

				-- Merge server-specific capabilities
				capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})

				-- Enable dynamic registration for common features
				if capabilities.workspace then
					capabilities.workspace.didChangeConfiguration = { dynamicRegistration = true }
				end

				-- Define the configuration using the new native API
				-- This replaces require('lspconfig')[server].setup(server_opts)
				vim.lsp.config(server, {
					install = true,
					cmd = server_opts.cmd,
					filetypes = server_opts.filetypes,
					settings = server_opts.settings,
					root_markers = server_opts.root_markers or server_opts.root_dir,
					capabilities = capabilities,
				})

				-- Enable the server
				vim.lsp.enable(server)
			end
		end
	end,
}
