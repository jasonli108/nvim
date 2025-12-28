return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "-" },
			topdelete = { text = "^" },
			changedelete = { text = "#" },
			untracked = { text = "?" },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = false,
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
			ignore_whitespace = false,
			virt_text_priority = 100,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil,
		max_file_length = 40000,
		preview_config = {
			border = "single",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},

		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			-- Highlight Groups
			vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#00ff00" })
			vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ffff00" })
			vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff0000" })

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			-- Navigation: Uses nav_hunk for modern Gitsigns API
			map("n", "]h", function()
				if vim.wo.diff then
					return "]h"
				end
				vim.schedule(function()
					gs.nav_hunk("next")
				end)
				return "<Ignore>"
			end, "Next Hunk")

			map("n", "[h", function()
				if vim.wo.diff then
					return "[h"
				end
				vim.schedule(function()
					gs.nav_hunk("prev")
				end)
				return "<Ignore>"
			end, "Prev Hunk")

			-- Actions
			map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
			map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
			map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
			map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
			map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
			map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
			map("n", "<leader>ghb", function()
				gs.blame_line({ full = true })
			end, "Blame Line")
			map("n", "<leader>ghd", gs.diffthis, "Diff This")
			map("n", "<leader>ghD", function()
				gs.diffthis("~")
			end, "Diff This ~")

			-- Text object
			map({ "o", "x" }, "ghh", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
		end,
	},
}
