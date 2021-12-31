local custom_codedark = require'lualine.themes.codedark'

local colors = {
	white = '#E4E4E4',
	black = '#3A3A3A',
	blue = '#9CDCFE',
	pink = '#C586C0',
	red = '#F44747'
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

require'lualine'.setup {
  options = {
    icons_enabled = false,
    theme = custom_codedark,
	component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {'NvimTree','packer'},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
	-- lualine_a = {},
    -- lualine_b = {},
    -- lualine_c = {},
    -- lualine_x = {},
    -- lualine_y = {},
    -- lualine_z = {},
  },
  extensions = {'quickfix','fugitive'}
}
require('tabline').setup{
    no_name = '[No Name]',    -- Name for buffers with no name
    modified_icon = '*',      -- Icon for showing modified buffer
    close_icon = '',         -- Icon for closing tab with mouse
    separator = "",          -- Separator icon on the left side
    padding = 3,             -- Prefix and suffix space
    color_all_icons = false,  -- Color devicons in active and inactive tabs
    always_show_tabs = false, -- Always show tabline
    right_separator = false,  -- Show right separator on the last tab
    show_index = true,       -- Shows the index of tab before filename
    show_icon = false,         -- Shows the devicon
}
