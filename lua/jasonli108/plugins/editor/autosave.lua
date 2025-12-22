return {
	"okuuva/auto-save.nvim",
	version = "^1.0.0", -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
	cmd = "ASToggle", -- optional for lazy loading on command
	event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
	-- lazy-loading on events
	--
	keys = {
		{ "<leader>n", ":ASToggle<CR>", desc = "Toggle auto-save" },
	},
	config = function()
		require("auto-save").setup({
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			enable = true,
			trigger_events = { -- See :h events
				immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
				defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
				cancel_deferred_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
				debounce_delay = 360000, -- Increase to 1.5 or 2 seconds
			},
			condition = function(buf)
				local fn = vim.fn

				-- don't save for special-buffers
				if fn.getbufvar(buf, "&buftype") ~= "" then
					return false
				end
				return true
			end,
		})

		local group = vim.api.nvim_create_augroup("auto-save", {})

		vim.api.nvim_create_autocmd("User", {
			pattern = "AutoSaveWritePost",
			group = group,
			callback = function(opts)
				if opts.data.saved_buffer ~= nil then
					local filename = vim.api.nvim_buf_get_name(opts.data.saved_buffer)
					print("AutoSave: saved " .. filename .. " at " .. vim.fn.strftime("%H:%M:%S"))
				end
			end,
		})
	end,
}
