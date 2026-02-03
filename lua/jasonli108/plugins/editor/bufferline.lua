return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local function safe_bdelete(buf)
			if buf == 0 then
				buf = vim.api.nvim_get_current_buf()
			end
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end

			local alt = vim.fn.bufnr("#")
			if alt > 0 and vim.api.nvim_buf_is_loaded(alt) and alt ~= buf then
				vim.cmd("buffer #")
			else
				vim.cmd("enew")
			end

			vim.api.nvim_buf_delete(buf, { force = false })
		end

		require("bufferline").setup({
			options = {
				-- CUSTOM FILTER ADDED HERE
				custom_filter = function(buf_number)
					-- 1. Hide buffers with the neo-tree filetype
					if vim.bo[buf_number].filetype == "neo-tree" then
						return false
					end
					-- 2. Hide buffers that are actually directories (common when opening nvim .)
					local buf_name = vim.api.nvim_buf_get_name(buf_number)
					if vim.fn.isdirectory(buf_name) == 1 then
						return false
					end
					-- 3. Show everything else
					return true
				end,

				close_command = function(buf)
					safe_bdelete(buf)
				end,
				right_mouse_command = function(buf)
					safe_bdelete(buf)
				end,
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
				},
				separator_style = "slant",
				show_buffer_close_icons = true,
				show_close_icon = true,
			},
		})

		-- Keymaps (unchanged)
		local map = vim.keymap.set
		local opts = { silent = true }
		map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", opts)
		map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", opts)
		map("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", { desc = "Toggle pin" })
		map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
		map("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "Close buffers to the right" })
		map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close buffers to the left" })
		map("n", "<leader>bd", function()
			safe_bdelete(0)
		end, { desc = "Delete buffer" })
		map("n", "<leader>bD", function()
			vim.api.nvim_buf_delete(0, { force = true })
		end, { desc = "Delete buffer (force)" })
	end,
}
