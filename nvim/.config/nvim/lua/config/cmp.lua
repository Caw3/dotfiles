vim.opt.completeopt = { "menu", "menuone", "noselect" }

local luasnip = require("luasnip")
luasnip.config.set_config({
	history = false,
})

local cmp = require("cmp")
cmp.setup({
	completion = {},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-p>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-y>"] = cmp.config.disable,
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<C-space>"] = cmp.mapping.confirm({ select = true }),
		["<C-j>"] = cmp.mapping(function()
			if luasnip.jumpable() then
				luasnip.jump(1)
			end
		end, { "i", "s" }),
		["<C-k>"] = cmp.mapping(function()
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = "luasnip", max_item_count = 3, group_index = 0, keyword_length = 2 },
		{ name = "nvim_lsp", max_item_count = 5, group_index = 1, keyword_length = 2 },
		{ name = "latex_symbols", max_item_count = 3, group_index = 3, keyword_length = 3 },
		{ name = "buffer", max_item_count = 3, group_index = 4, keyword_length = 4 },
		{ name = "path", max_item_count = 10 },
	}),
	formatting = {
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lsp = "[LS]",
				treesitter = "[TS]",
				path = "/",
				buffer = "[B]",
				luasnip = "[S]",
			})[entry.source.name]
			return vim_item
		end,
	},
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
