return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Snippet engine
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			config = function()
				local ok = pcall(require, "jasonli108.snips")
				if not ok then
					vim.notify("LuaSnip: custom snippets not found", vim.log.levels.WARN)
				end
			end,
		},

		-- CMP sources (NON-AI ONLY)
		"folke/lazydev.nvim",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp", -- Required for Pyright built-ins
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"rafamadriz/friendly-snippets",
	},

	opts = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		return {
			-- 🧠 Disable CMP when minuet inline AI is active
			enabled = function()
				local ok, minuet = pcall(require, "minuet")
				if ok and minuet.is_active and minuet.is_active() then
					return false
				end
				return true
			end,

			-- 🔴 Never preselect (AI-safe)
			preselect = cmp.PreselectMode.None,

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			-- 🧠 Manual-only completion
			completion = {
				autocomplete = false, -- You MUST press <C-Space> to see print, len, etc.
				completeopt = "menu,menuone,noinsert",
			},

			mapping = cmp.mapping.preset.insert({
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				-- Explicit CMP trigger (Use this to see built-ins)
				["<C-Space>"] = cmp.mapping.complete(),

				-- 🔴 Confirm must be explicit
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				}),

				-- Tab logic: CMP > snippets > fallback
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),

			-- 🚫 NO AI SOURCES — minuet owns AI
			sources = cmp.config.sources({
				-- 🧠 Lazydev (Neovim configuration completion)
				{
					name = "lazydev",
					group_index = 0, -- Skip loading LuaLS completions for these items
				},
			}, {
				-- 🧠 LSP built-ins
				{ name = "nvim_lsp", priority = 1000 },
				{ name = "nvim_lsp_signature_help", priority = 750 },

				-- Snippets (Built-in patterns like if __name__ == "__main__")
				{ name = "luasnip", priority = 600 },
			}, {
				-- Fallbacks
				{ name = "buffer", priority = 300 },
				{ name = "path", priority = 200 },
			}),

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, item)
					local menu_icon = {
						lazydev = "",
						nvim_lsp = "⋗",
						nvim_lsp_signature_help = "  ",
						luasnip = "λ",
						buffer = "Ω",
						path = "🖫",
						git = "",
					}

					item.menu = menu_icon[entry.source.name] or ""
					return item
				end,
			},
		}
	end,

	config = function(_, opts)
		local cmp = require("cmp")
		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip").config.setup({})
		cmp.setup(opts)
	end,
}
