return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewRefresh",
		"DiffviewToggleFiles",
		"DiffviewFileHistory",
	},
	keys = {
		{ "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
		{ "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
		{ "<leader>gdr", "<cmd>DiffviewRefresh<cr>", desc = "Diffview Refresh" },
		{ "<leader>gdt", "<cmd>DiffviewToggleFiles<cr>", desc = "Diffview Toggle Files" },
		{ "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview File History" },
	},
	opts = {
		enhanced_diff_hl = true, -- Better syntax highlighting in diffs
		use_icons = true, -- Requires a Nerd Font
		view = {
			default = {
				-- Open Diffview in a new tab by default
				layout = "diff2_horizontal",
			},
		},
		file_panel = {
			listing_style = "list", -- "list" or "tree"
			tree_config = {
				flatten_dirs = true,
				folder_statuses = "only_folded",
			},
		},
	},
}
