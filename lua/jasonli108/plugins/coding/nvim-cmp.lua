-- Auto-completion / Snippets (AI-first tuned)
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

		-- CMP sources
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"rafamadriz/friendly-snippets",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp-signature-help",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		require("luasnip.loaders.from_vscode").lazy_load()
		luasnip.config.setup({})

		cmp.setup({
			-- 🔴 AI safety: do not preselect
			preselect = cmp.PreselectMode.None,

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			completion = {
				completeopt = "menu,menuone,noinsert",
			},

			mapping = cmp.mapping.preset.insert({
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),

				-- 🔴 AI-safe confirm
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				}),

				-- Tab: CMP > snippets > fallback
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

			-- 🧠 AI-FIRST SOURCE PRIORITY
			sources = cmp.config.sources({
				-- AI
				{ name = "codeium", priority = 1000 },
				{ name = "codecompanion", priority = 900 },
				{ name = "minuet", priority = 850 },

				-- LSP
				{ name = "nvim_lsp_signature_help", priority = 750 },
				{ name = "nvim_lsp", priority = 700 },

				-- Snippets
				{ name = "luasnip", priority = 600 },

				-- Fallbacks
				{ name = "buffer", priority = 300 },
				{ name = "path", priority = 200 },
			}),

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			formatting = {
				expandable_indicator = true,
				fields = { "kind", "abbr", "menu" },
				format = function(entry, item)
					local menu_icon = {
						codeium = "󰚩",
						codecompanion = "",
						minuet = "󱙺",
						nvim_lsp = "⋗",
						nvim_lsp_signature_help = "󰏫",
						luasnip = "λ",
						buffer = "Ω",
						path = "🖫",
					}

					item.menu = menu_icon[entry.source.name] or "?"
					return item
				end,
			},
		})
	end,
}
