return {
	"stevearc/conform.nvim",

	event = { "BufWritePre" },
	cmd = { "ConformInfo" },

	keys = {
		{
			"<leader>mp",
			function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 8000,
				})
			end,
			mode = { "n", "v" },
			desc = "Format file or range (Conform)",
		},

		{
			"<leader>mf",
			function()
				vim.lsp.buf.format({ async = true })
			end,
			mode = { "n", "v" },
			desc = "LSP native format",
		},
	},

	opts = {
		format_on_save = function(bufnr)
			-- disable autoformat if toggled
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end

			-- run nvim-lint if installed
			local has_lint, lint = pcall(require, "lint")
			if has_lint then
				lint.try_lint()
			end

			-- check for diagnostics errors
			local diagnostics = vim.diagnostic.get(bufnr, {
				severity = vim.diagnostic.severity.ERROR,
			})

			if #diagnostics > 0 then
				vim.notify("Format aborted: Errors found.", vim.log.levels.WARN, { title = "Conform" })
				return
			end

			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end,

		-- optional formatter setup
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format", "black" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			go = { "gofmt" },
		},
	},

	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)
	end,
}
