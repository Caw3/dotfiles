vim.o.background = "dark"
vim.cmd("colorscheme codedark")
vim.cmd("highlight clear SignColumn")
vim.cmd("hi EndOfBuffer guifg=#1E1E1E")
vim.cmd("se cursorline")
vim.cmd("hi clear cursorline")

local custom_codedark = require("lualine.themes.codedark")

local colors = {
	white = "#E4E4E4",
	black = "#3A3A3A",
	blue = "#9CDCFE",
	pink = "#C586C0",
	red = "#F44747",
}
custom_codedark.normal.a.bg = colors.black
custom_codedark.normal.a.fg = colors.white
custom_codedark.normal.b.fg = colors.white

custom_codedark.insert.a.bg = colors.black
custom_codedark.insert.a.fg = colors.blue
custom_codedark.insert.b.fg = colors.blue

custom_codedark.visual.a.bg = colors.black
custom_codedark.visual.a.fg = colors.pink
custom_codedark.visual.b.fg = colors.pink

custom_codedark.replace.a.bg = colors.black
custom_codedark.replace.a.fg = colors.red
custom_codedark.replace.b.fg = colors.red

require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = custom_codedark,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "fugitive", "NvimTree", "packer", "alpha" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { { "filename", file_status = true, path = 1 } },
		lualine_x = {
			{
				"diff",
				colored = true,
				diff_color = {
					-- added    = {fg = colors.blue},
					modified = { fg = colors.blue },
					removed = { fg = colors.red },
				},
			},
			"diagnostics",
		},
		lualine_y = { "encoding", "filetype" },
		lualine_z = { "%l/%L" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		-- lualine_a = {},
		-- lualine_b = {},
		-- lualine_c = {},
		-- lualine_x = {},
		-- lualine_y = {},
		-- lualine_z = {},
	},
	extensions = { "quickfix" },
})
