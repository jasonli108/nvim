return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},

	deactivate = function()
		vim.cmd("Neotree close")
	end,

	opts = {
		group_empty_dirs = true,

		filesystem = {
			group_empty_dirs = true,
			filtered_items = {
				visible = false,
				hide_dotfiles = false,
				hide_git_ignored = true,
			},
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
			window = {
				mappings = {
					["i"] = "toggle_hidden",
				},
			},
		},

		-- GIT STATUS SPECIFIC CONFIG
		git_status = {
			group_empty_dirs = true,
			window = {
				mappings = {
					-- Use the same navigation as filesystem
					["l"] = "open",
					["h"] = "close_node",
					-- Default git actions
					["A"] = "git_add_all",
					["ga"] = "git_add_file",
					["gu"] = "git_unstage_file",
				},
			},
		},

		default_component_configs = {
			git_status = {
				symbols = {
					added = "✚",
					deleted = "✖",
					modified = "",
					renamed = "  ",
					untracked = "",
					ignored = "",
					unstaged = "  ",
					staged = "",
					conflict = "",
				},
			},
		},

		window = {
			close_if_last_window = true,
			mappings = {
				-- Global navigation (works in both if not overridden)
				["l"] = "open",
				["h"] = "close_node",
				["<space>"] = "none",

				-- View Switching
				["gs"] = function()
					vim.cmd("Neotree focus git_status left")
				end,
				["gf"] = function()
					vim.cmd("Neotree focus filesystem left")
				end,

				-- Your custom Git functions (ga, gu, gc, gm)
				["ga"] = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					vim.fn.system("git add " .. vim.fn.shellescape(path))
					require("neo-tree.sources.manager").refresh(state.name)
				end,

				["gu"] = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					vim.fn.system("git reset " .. vim.fn.shellescape(path))
					require("neo-tree.sources.manager").refresh(state.name)
				end,

				["gc"] = function(state)
					vim.ui.input({ prompt = "Commit Message: " }, function(msg)
						if not msg or msg == "" then
							return
						end
						local out = vim.fn.system("git commit -m " .. vim.fn.shellescape(msg))
						if vim.v.shell_error ~= 0 then
							vim.notify("Git commit failed: " .. out, vim.log.levels.ERROR)
						else
							require("neo-tree.sources.manager").refresh(state.name)
							print("Committed successfully!")
						end
					end)
				end,

				["gm"] = function(state)
					local out = vim.fn.system("git commit --amend --no-edit")
					if vim.v.shell_error ~= 0 then
						vim.notify("Amend failed: " .. out, vim.log.levels.ERROR)
					else
						require("neo-tree.sources.manager").refresh(state.name)
						print("Amended successfully!")
					end
				end,

				["Y"] = {
					function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						vim.fn.setreg("+", path, "c")
					end,
					desc = "Copy Path",
				},
			},
		},
	},

	config = function(_, opts)
		require("neo-tree").setup(opts)
	end,
}
