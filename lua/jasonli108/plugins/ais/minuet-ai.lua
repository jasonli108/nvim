return {
	"milanglacier/minuet-ai.nvim",
	lazy = false,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("minuet").setup({
			-- ⏱️ Responsiveness (balanced for local Ollama)
			throttle = 1200,
			debounce = 600,

			-- 🔌 Provider
			provider = "openai_fim_compatible",

			-- Inline ghost text behavior
			add_single_line_entry = true,

			provider_options = {
				openai_fim_compatible = {
					-- Ollama FIM model
					model = "qwen2.5-coder:latest",

					-- ✅ Correct Ollama OpenAI-compatible endpoint
					end_point = "http://localhost:11434/v1/completions",

					-- Ollama ignores this, but plugin requires it
					api_key = "TERM",

					name = "ollama",
					stream = true,

					-- Passed directly to Ollama
					optional = {
						max_tokens = 256,
						temperature = 0.2,

						-- IMPORTANT: stop tokens for FIM
						stop = {
							"<|file_separator|>",
							"<|endoftext|>",
						},
					},
				},
			},

			-- 👻 Inline virtual text UI
			virtualtext = {
				auto_trigger_ft = { "*" },
				keymap = {
					accept = "<C-a>",
					accept_line = "<C-A>",
					next = "<C-n>",
					prev = "<C-p>",
					dismiss = "<C-e>",
				},
			},

			-- 🧠 LSP-aware indentation
			lsp = {
				enabled_ft = { "*" },
				adjust_indentation = false, -- safer for Python / YAML
			},

			-- 🚫 CMP integration disabled (CMP is manual-only)
			cmp = {
				enable_auto_complete = false,
			},
		})
	end,
}
