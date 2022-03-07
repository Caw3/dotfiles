local colors = {
	white = "#E4E4E4",
	black = "#1e1e1e",
	grey = "#252526",
	blue = "#9CDCFE",
	pink = "#C586C0",
	red = "#F44747",
}

local custom_codedark = {
  normal = {
    b = { fg = colors.white, bg = colors.black },
    a = { fg = colors.white, bg = colors.black, gui = 'bold' },
    c = { fg = colors.white, bg = colors.black },
  },
  visual = {
    b = { fg = colors.white, bg = colors.black },
    a = { fg = colors.white, bg = colors.black, gui = 'bold' },
  },
  inactive = {
    b = { fg = colors.white, bg = colors.grey },
    a = { fg = colors.white, bg = colors.grey, gui = 'bold' },
    c = { fg = colors.white, bg = colors.grey },
  },
  replace = {
    b = { fg = colors.lightred, bg = colors.black },
    a = { fg = colors.white, bg = colors.black, gui = 'bold' },
    c = { fg = colors.white, bg = colors.black },
  },
  insert = {
    b = { fg = colors.white, bg = colors.black },
    a = { fg = colors.white, bg = colors.black, gui = 'bold' },
    c = { fg = colors.white, bg = colors.black },
  },
  terminal = {
    b = { fg = colors.black, bg = colors.black },
    a = { fg = colors.black, bg = colors.black, gui = 'bold' },
    c = { fg = colors.black, bg = colors.black },
  }
}

require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = custom_codedark,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "fugitive", "NvimTree", "packer" },
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
					added = "DiffAdd",
					modified = "DiffChange",
					removed = "DiffDelete",
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
