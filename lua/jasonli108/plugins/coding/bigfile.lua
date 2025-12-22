return {
	"LunarVim/bigfile.nvim",
	event = "BufReadPre",
	opts = {
		filesize = 2, -- MiB; size at which a file is considered "big"
		pattern = { "*" }, -- File patterns to monitor
		features = { -- List of features to disable for big files
			"indent_blankline",
			"illuminate",
			"lsp",
			"treesitter",
			"syntax",
			"matchparen",
			"vimopts",
			"filetype",
		},
	},
	config = function(_, opts)
		require("bigfile").setup(opts)
	end,
}
