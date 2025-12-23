return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			-- 1. Organize/Fix imports, 2. Format code
			python = { "ruff_organize_imports", "ruff_format" },
			lua = { "stylua" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
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
