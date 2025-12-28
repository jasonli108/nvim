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
		-- Navigation Shortcuts
		{ "[g", "k<cmd>normal! [c<cr>", desc = "Previous Diff Hunk" },
		{ "]g", "j<cmd>normal! ]c<cr>", desc = "Next Diff Hunk" },
	},
	opts = {
		enhanced_diff_hl = true,
		use_icons = true,
		view = {
			default = {
				layout = "diff2_horizontal",
			},
		},
		file_panel = {
			listing_style = "list",
			tree_config = {
				flatten_dirs = true,
				folder_statuses = "only_folded",
			},
		},
	},
}
