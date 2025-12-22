return {
	{
		"stevearc/aerial.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePost" },
		opts = {
			attach_mode = "global",
			backends = { "lsp", "treesitter", "markdown", "man" },
			show_guides = true,
			layout = { resize_to_content = false },
			-- Ensure we track the cursor movement for the statusline
			highlight_closest = true,
			update_events = "CursorMoved,CursorMovedI,BufWritePost",
			guides = {
				mid_item = "├╴",
				last_item = "└╴",
				nested_top = "│ ",
				whitespace = "  ",
			},
		},
		keys = {
			{ "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
		},
	},
}
