return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end

			-- TRIGGER LINT/DIAGNOSTIC REFRESH
			-- 1. If using nvim-lint, force it to run synchronously
			local has_lint, lint = pcall(require, "lint")
			if has_lint then
				lint.try_lint()
			end

			-- 2. Force LSP to recognize changes (sends 'didChange' to server)
			-- This ensures diagnostics are up to date before we check them
			vim.cmd("silent! write")

			-- SAFEGUARD: Check for errors AFTER forcing the refresh
			local diagnostics = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
			if #diagnostics > 0 then
				-- Optional: notify the user why it didn't format
				vim.notify("Format aborted: Errors found.", vim.log.levels.WARN, { title = "Conform" })
				return
			end

			return { timeout_ms = 500, lsp_format = "fallback" }
		end,
	},
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)

		-- Keymap for Conform formatting (handles both buffer and visual range)
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 8000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		-- Standard LSP-only formatting fallback
		vim.keymap.set({ "n", "v" }, "<leader>mf", function()
			vim.lsp.buf.format({ async = true })
		end, { noremap = true, silent = true, desc = "LSP native format" })
	end,
}
