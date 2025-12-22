return {
	"debugloop/telescope-undo.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>u", "<cmd>Telescope undo<cr>", desc = "Undo History" },
	},
	opts = {
		extensions = {
			undo = {
				side_by_side = true,
				layout_strategy = "vertical",
				layout_config = {
					preview_height = 0.8,
				},
				mappings = {
					i = {
						-- We wrap the require in a function so it's only called when you press the key
						["<cr>"] = function(bufnr)
							return require("telescope-undo.actions").restore(bufnr)
						end,
						["<S-cr>"] = function(bufnr)
							return require("telescope-undo.actions").yank_additions(bufnr)
						end,
						["<C-cr>"] = function(bufnr)
							return require("telescope-undo.actions").yank_deletions(bufnr)
						end,
					},
				},
			},
		},
	},
	config = function(_, opts)
		-- This merges your 'undo' config into telescope and loads the extension
		require("telescope").setup(opts)
		require("telescope").load_extension("undo")
	end,
}
