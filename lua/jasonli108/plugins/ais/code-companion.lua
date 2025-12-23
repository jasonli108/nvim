return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			adapters = {
				gemini_cli = function()
					return require("codecompanion.adapters").extend("gemini_cli", {
						command = {
							-- The executable name and necessary ACP flag
							default = { "gemini", "--experimental-acp" },
						},
						env = {
							-- Sets the API key from your system's environment variables
							-- GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY"),
						},
					})
				end,
			},
			strategies = {
				-- Assign the CLI adapter as the default for all modes
				chat = { adapter = "gemini_cli" },
				inline = { adapter = "gemini_cli" },
				agent = { adapter = "gemini_cli" },
			},
		})

		-- Recommended Shortcuts
		local map = vim.keymap.set

		-- Open the AI Chat (Toggle)
		map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat" })

		-- Run an Inline transformation (e.g., "Refactor this")
		map({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI Inline" })

		-- Open the Actions Menu (The 'Swiss Army Knife')
		map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions" })

		-- Quick shortcut to add current selection to the chat
		map("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add to AI Chat" })
	end,
}
