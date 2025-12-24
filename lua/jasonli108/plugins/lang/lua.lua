local lsp_server = "lua_ls"

return {
	-- 1. Tools (Mason)
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "codespell", "stylua", "shfmt", lsp_server })
			return opts
		end,
	},

	-- 2. LSP Settings (The LazyVim way)
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}

			opts.servers.lua_ls = {
				-- Fix the "not executable" warning by pointing directly to Mason
				cmd = { vim.fn.stdpath("data") .. "/mason/bin/lua-language-server" },

				-- Fix the "expected table, got function" error
				-- Use root_markers (table) instead of root_dir (function) for 0.11 compatibility
				root_markers = { ".git", ".luarc.json", ".luarc.jsonc", "init.lua" },

				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = { vim.env.VIMRUNTIME },
							checkThirdParty = false,
						},
						telemetry = { enable = false },
						hint = { enable = true },
					},
				},
			}
			return opts
		end,
	},

	-- 3. Formatter
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.lua = { "stylua" }
			return opts
		end,
	},

	-- 4. Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "lua", "luadoc", "luap" })
			return opts
		end,
	},
}
