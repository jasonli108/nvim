-- Status line
return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"linrongbin16/lsp-progress.nvim",
		"stevearc/aerial.nvim", -- Add this as a dependency
	},

	opts = {
		options = {
			theme = "codedark",
			globalstatus = true,
			disabled_filetypes = {
				statusline = { "neo-tree", "aerial" },
				winbar = { "neo-tree" },
			},
		},

		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },

			lualine_c = {
				{
					"filename",
					file_status = true,
					path = 4,
					symbols = { modified = "[+]", readonly = "[-]", unnamed = "" },
					cond = function()
						return vim.fn.bufname() ~= ""
					end,
				},
				-- 🚀 ADD AERIAL HERE
				{
					"aerial",
					sep = " > ",
					depth = 5,
					colored = true,
				},
			},

			lualine_x = {
				-- 🤖 CodeCompanion Spinner
				{
					function()
						-- Check if codecompanion is loaded
						local ok, companion = pcall(require, "codecompanion")
						if not ok then
							return ""
						end

						-- Get the current status/spinner
						local status = require("codecompanion.status").get_spinner()

						-- If status is nil or empty, return nothing
						if not status or status == "" then
							return ""
						end

						return "🤖 " .. status
					end,
					color = { fg = "#569CD6" }, -- Blue color to match your theme
				},
				-- Existing LSP progress
				{
					function()
						return require("lsp-progress").progress()
					end,
					cond = function()
						return package.loaded["lsp-progress"]
					end,
				},
				"encoding",
				"filetype",
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}
