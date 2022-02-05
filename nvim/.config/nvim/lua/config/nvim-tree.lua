vim.cmd([[
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 1,
    \ }
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '>>',
    \ 'git': {
    \   'unstaged': "*",
    \   'staged': "+",
    \   'unmerged': "-m",
    \   'renamed': "->",
    \   'untracked': "?",
    \   'deleted': "-",
    \   'ignored': "i"
    \   },
    \ 'folder': {
    \   'arrow_open': "v",
    \   'arrow_closed': ">",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': ">>",
    \   'symlink_open': "",
    \   }
    \ }
]])
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_highligt_opened_files = 1
vim.g.nvim_tree_respect_buf_cwd = 1
vim.cmd("let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 }")

local keymaps = {
  { key = {"<CR>", "o", "l", "<2-LeftMouse>"}, action = "edit" },
  { key = {"O"},                          action = "edit_no_picker" },
  { key = {"<2-RightMouse>", "<C-Space>"},    action = "cd" },
  { key = "<C-v>",                        action = "vsplit" },
  { key = "<C-x>",                        action = "split" },
  { key = "<C-t>",                        action = "tabnew" },
  { key = "K",                            action = "prev_sibling" },
  { key = "J",                            action = "next_sibling" },
  { key = "P",                            action = "parent_node" },
  { key = "h",                            action = "close_node" },
  { key = "<Tab>",                        action = "preview" },
  { key = "H",                            action = "first_sibling" },
  { key = "L",                            action = "last_sibling" },
  { key = "I",                            action = "toggle_ignored" },
  { key = "<BS>",                            action = "toggle_dotfiles" },
  { key = "R",                            action = "refresh" },
  { key = "t",                            action = "create" },
  { key = "dD",                            action = "remove" },
  { key = "dT",                           action = "trash" },
  { key = "a",                            action = "rename" },
  { key = "<C-r>",                        action = "full_rename" },
  { key = "dd",                            action = "cut" },
  { key = "yy",                            action = "copy" },
  { key = "pp",                            action = "paste" },
  { key = "yn",                            action = "copy_name" },
  { key = "yp",                            action = "copy_path" },
  { key = "yP",                           action = "copy_absolute_path" },
  { key = "gN",                           action = "prev_git_item" },
  { key = "gn",                           action = "next_git_item" },
  { key = "gu",                            action = "dir_up" },
  { key = "s",                            action = "system_open" },
  { key = "q",                            action = "close" },
  { key = "g?",                           action = "toggle_help" },
}

require("nvim-tree").setup({
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = {},
	auto_close = false,
	open_on_tab = false,
	hijack_cursor = true,
	update_cwd = true,
	update_to_buf_dir = {
		enable = true,
		auto_open = true,
	},
	diagnostics = {
		enable = false,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	filters = {
		dotfiles = false,
		custom = {},
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 500,
	},
	view = {
		width = 35,
		height = 30,
		hide_root_folder = false,
		side = "left",
		auto_resize = true,
		mappings = {
			custom_only = true,
			list = keymaps
		},
		number = false,
		relativenumber = false,
		signcolumn = "yes",
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
})
