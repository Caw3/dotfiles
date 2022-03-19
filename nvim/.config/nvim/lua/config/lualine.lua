local colors = {
	white = "#e4e4e4",
	black = "#1e1e1e",
	grey = "#252526",
	blue = "#9CDCFE",
	green = "#608B4E",
	magenta = "#C586C0",
	red = "#F44747",
}

local custom_codedark = {
	normal = {
		b = { fg = colors.white, bg = colors.grey },
		a = { fg = colors.white, bg = colors.grey, gui = "bold" },
		c = { fg = colors.white, bg = colors.grey },
	},
	visual = {
		b = { fg = colors.white, bg = colors.grey },
		a = { fg = colors.white, bg = colors.grey, gui = "bold" },
	},
	inactive = {
		b = { fg = colors.white, bg = colors.grey },
		a = { fg = colors.white, bg = colors.grey, gui = "bold" },
		c = { fg = colors.white, bg = colors.grey },
	},
	replace = {
		b = { fg = colors.lightred, bg = colors.grey },
		a = { fg = colors.white, bg = colors.grey, gui = "bold" },
		c = { fg = colors.white, bg = colors.grey },
	},
	insert = {
		b = { fg = colors.white, bg = colors.grey },
		a = { fg = colors.white, bg = colors.grey, gui = "bold" },
		c = { fg = colors.white, bg = colors.grey },
	},
	terminal = {
		b = { fg = colors.grey, bg = colors.grey },
		a = { fg = colors.grey, bg = colors.grey, gui = "bold" },
		c = { fg = colors.grey, bg = colors.grey },
	},
}

require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = custom_codedark,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "fugitiveblame", "fugitive", "NvimTree", "packer" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "branch" },
		lualine_b = {},
		lualine_c = { { "filename", file_status = true, path = 1 } },
		lualine_x = {
			{
				"diff",
				colored = true,
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.magenta },
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
	tabline = {},
	extensions = { "quickfix" },
})
