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

		-- 4. NEW 2025 NATIVE SETUP
		for server, server_opts in pairs(opts.servers) do
			-- Get default capabilities and specifically enable dynamic registration
			-- This tells the server that Neovim is ready to handle these requests
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- Check if your server_opts already has capabilities to merge
			capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})

			-- Explicitly enable dynamic registration for common features
			-- This stops warnings from servers that "expect" this support
			if capabilities.workspace then
				capabilities.workspace.didChangeConfiguration = { dynamicRegistration = true }
			end

			-- Define the configuration using the new 2025 native API
			vim.lsp.config(server, {
				install = true,
				cmd = server_opts.cmd,
				filetypes = server_opts.filetypes,
				settings = server_opts.settings,
				root_markers = server_opts.root_dir,
				capabilities = capabilities, -- Pass the updated capabilities here
			})

			-- Enable the server
			vim.lsp.enable(server)
		end
	end,
}
