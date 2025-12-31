return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			-- 🚀 ADD THIS SECTION HERE
			display = {
				action_palette = {
					provider = "telescope", -- Options: "telescope", "mini.pick", "fzf_lua"
				},
				chat = {
					show_token_count = true,
				},
				inline = {
					diff = {
						enabled = true,
					},
				},
			},

			adapters = {
				gemini_cli = function()
					return require("codecompanion.adapters").extend("gemini_cli", {
						command = {
							default = { "gemini", "--experimental-acp" },
						},
					})
				end,
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								-- default = "qwen3:8b",
								default = "qwen2.5-coder:latest",
							},
							num_ctx = {
								default = 8192,
							},
						},
					})
				end,
			},
			strategies = {
				-- Now using Ollama (Qwen) as the primary driver for everything
				chat = { adapter = "ollama" },
				inline = { adapter = "ollama" },
				agent = { adapter = "ollama" },
			},
			-- Ensure you also have the following to allow the status to broadcast
			opts = {
				send_code = true,
			},
		})

		-- Keymaps
		local map = vim.keymap.set
		map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat (Ollama)" })
		map({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI Inline (Ollama)" })
		map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions" })
		map("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add to AI Chat" })

		-- Optional: Keep a quick way to launch Gemini if Ollama struggles with a task
		map({ "n", "v" }, "<leader>ag", "<cmd>CodeCompanionChat adapter=gemini_cli<cr>", { desc = "AI Chat (Gemini)" })
	end,
}
