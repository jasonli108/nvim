return {
	-- 1. Mason Tools: Use 'vtsls' and 'js-debug-adapter'
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			-- FIXED: Verified for late 2025 naming
			vim.list_extend(opts.ensure_installed, { "vtsls", "js-debug-adapter", "prettierd" })
			return opts
		end,
	},

	-- 2. LSP Configuration: Clean deprecations
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			-- v3.0.0 cleanup: Ensure old names are strictly disabled
			opts.servers.tsserver = { enabled = false }
			opts.servers.ts_ls = { enabled = false }

			opts.servers.vtsls = {
				-- vtsls settings remain excellent for 2025 performance
				settings = {
					vtsls = {
						autoUseWorkspaceTsdk = true,
						experimental = { completion = { enableServerSideFuzzyMatch = true } },
					},
					typescript = {
						inlayHints = {
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
						},
					},
				},
			}
			return opts
		end,
	},

	-- 3. Debugging (DAP): Fixed Disconnection logic
	{
		"mfussenegger/nvim-dap",
		optional = true,
		config = function()
			local dap = require("dap")
			local adapter_path = vim.fn.stdpath("data")
				.. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

			-- Common adapter configuration for all PWA types
			local adapter_config = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = { adapter_path, "${port}" },
				},
				-- 2025 Fix: Essential timeout for modern browser handshakes
				initialize_timeout_sec = 20,
			}

			-- FIXED: Registering both aliases ensures the 'type' in configs matches
			dap.adapters["pwa-node"] = adapter_config
			dap.adapters["pwa-chrome"] = adapter_config

			local js_config = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch File (Node)",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-chrome",
					request = "launch",
					name = "Debug Chrome (Vite/React)",
					url = "http://localhost:5173", -- Ensure this matches your terminal exactly
					webRoot = "${workspaceFolder}",
					protocol = "inspector",
					sourceMaps = true,
					-- 2025 FIX: Change false to true to use a fresh, unlocked profile
					userDataDir = true,
					-- Or specify a temp path: userDataDir = "/tmp/nvim-chrome-debug",
					runtimeExecutable = "/usr/bin/google-chrome", -- Double check this path!
					timeout = 30000,
					-- Force the browser to navigate to the URL if it gets stuck
					runtimeArgs = { "--remote-debugging-port=9222" },
				},
			}

			for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact", "vue", "svelte" }) do
				dap.configurations[lang] = js_config
			end
		end,
	},

	-- 4. Formatting: Prettierd remains standard for 2025
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.javascript = { "prettierd" }
			opts.formatters_by_ft.typescript = { "prettierd" }
			opts.formatters_by_ft.typescriptreact = { "prettierd" }
			return opts
		end,
	},
}
