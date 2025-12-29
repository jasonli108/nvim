return {
	"milanglacier/minuet-ai.nvim",
	config = function()
		require("minuet").setup({
			-- Throttling & Debounce: These are high (3.5s total delay).
			-- If it feels laggy, consider lowering throttle to 1000.
			throttle = 2000,
			debounce = 1500,
			provider = "openai_fim_compatible",
			add_single_line_entry = true,

			provider_options = {
				openai_fim_compatible = {
					model = "qwen2.5-coder:latest",
					end_point = "http://localhost:11434/v1/completions", -- Fixed: no underscore
					api_key = "TERM",
					name = "Ollama",
					stream = true,
					optional = {
						max_tokens = 256,
						temperature = 0.2,
						-- Adding stop tokens prevents the model from "hallucinating"
						-- the rest of your file or generating extra end-tags.
						stop = { "<|file_separator|>", "<|endoftext|>", "\n\n" },
					},
				},
			},

			virtualtext = {
				auto_trigger_ft = { "*" },
				keymap = {
					accept = "<C-A>",
					accept_line = "<C-a>",
					next = "<C-n>",
					prev = "<C-p>",
					dismiss = "<C-e>",
				},
			},

			lsp = {
				enabled_ft = { "*" },
				-- Warning: adjust_indentation is known to have edge cases in 2025
				-- for indentation-sensitive languages like Python.
				adjust_indentation = true,
			},
		})
	end,
}
