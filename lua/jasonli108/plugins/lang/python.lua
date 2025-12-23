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
			})
		end,
	},

	-- 2. LSP Setup
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			opts.servers[lsp_servers.python_ls] = {
				settings = { python = { analysis = { autoSearchPaths = true } } },
			}
		end,
	},

	-- 3. Formatting (Forced Import Movement)

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" }, -- Run on save
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				python = { "isort", "black" },
			},
			formatters = {
				isort = {
					-- This flag forces imports past code barriers to the very top
					prepend_args = { "--float-to-top" },
				},
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},

	-- 4. Venv Selector (FIXED SYNTAX)
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
		end,
	},
}
