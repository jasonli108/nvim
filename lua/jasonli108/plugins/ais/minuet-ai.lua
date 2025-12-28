-- Using Lazy.nvim plugin manager
return {
	"milanglacier/minuet-ai.nvim",
	config = function()
		require("minuet").setup({
			provider = "gemini",
			provider_options = {
				gemini = {
					model = "gemini-1.5-flash", -- or 'gemini-2.0-flash' for 2025 speed
					system_prompt = "You are a specialized code completion assistant...",
					api_key = "AIzaSyCmluUggfpxnF1FVlRw7Clm4Se9sN2DLbE",
				},
			},
		})
	end,
}
