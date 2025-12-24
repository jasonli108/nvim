-- Example configuration for maximize.nvim (requires lazy.nvim or similar)
return {
	"declancm/maximize.nvim",
	config = function()
		require("maximize").setup()
		-- Map <leader>z to toggle maximization of the current window
		vim.keymap.set("n", "<leader>zm", "<cmd>Maximize<CR>", { desc = "Toggle window maximization" })
	end,
}
