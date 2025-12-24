return {
	"MagicDuck/grug-far.nvim",
	config = function()
		require("grug-far").setup({
			-- Options:
			headerMaxWidth = 80,
			-- Use 'ast-grep' for structural searches (requires ast-grep installed)
			engines = {
				astgrep = {
					path = "ast-grep",
				},
			},
		})
	end,
	keys = {
		{
			"<leader>sr",
			function()
				require("grug-far").open({ transient = true })
			end,
			mode = { "n", "v" },
			desc = "Search and Replacew(Grug-far)",
		},
		{
			"<leader>sW",
			function()
				require("grug-far").open({ wprefills = { search = vim.fn.expand("<cword>") } })
			end,
			mode = "n",
			desc = "Search current word (Grug-far)",
		},
	},
}
