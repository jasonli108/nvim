local lsp_servers = {
	python_ls = "pyright",
	python_linter = "ruff",
}

return {
	-- 1. Mason Tools
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				lsp_servers.python_ls,
				lsp_servers.python_linter,
				"black",
				"debugpy",
				"mypy",
				"isort",
			})
			return opts
		end,
	},

	-- 2. LSP Setup (The fix for built-ins is here)
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		opts = function(_, opts)
			-- This bridge allows Pyright to send built-in functions to nvim-cmp
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			opts.servers = opts.servers or {}
			opts.servers[lsp_servers.python_ls] = {
				capabilities = capabilities, -- CRITICAL: Enables built-ins/snippets
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							extraPaths = { "." },
							useLibraryCodeForTypes = true,
							diagnosticMode = "openFilesOnly",
							typeCheckingMode = "basic",
						},
					},
				},
			}
			return opts
		end,
	},

	-- 3. Formatting (Black 120 + Forced Import Movement)
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters = opts.formatters or {}

			opts.formatters_by_ft.python = { "isort", "black" }

			opts.formatters.black = {
				prepend_args = { "--line-length", "120" },
			}

			opts.formatters.isort = {
				prepend_args = { "--float-to-top" },
			}

			opts.format_on_save = { timeout_ms = 500, lsp_fallback = true }
			return opts
		end,
	},

	-- 4. Venv Selector
	{
		"linux-cultist/venv-selector.nvim",
		branch = "regexp",
		cmd = "VenvSelect",
		opts = { settings = { options = { notify_user_on_venv_activation = true } } },
		keys = { { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" } },
	},

	-- 5. Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "python", "ninja", "rst" })
			return opts
		end,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
