-- Settings
vim.o.shell = "/bin/zsh"
vim.cmd("set termguicolors")
vim.cmd("set scl=yes")

vim.cmd("set nu")

vim.o.encoding = "utf-8"

vim.o.tabstop = 4
vim.o.shiftwidth = vim.o.tabstop
vim.o.smartindent = true
vim.o.autoindent = true

vim.o.hidden = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.backup = false

vim.o.wrap = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 8

vim.o.mouse = "a"

-- Search
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.cmd("set nohlsearch")

vim.cmd("set nocompatible")
vim.cmd("filetype plugin indent on")
vim.cmd("set noshowmode")
vim.cmd("set noshowcmd")
vim.cmd("set shortmess+=F")

-- Cosemetic
vim.o.background = "dark"
vim.cmd("colorscheme codedark")
vim.cmd("highlight clear SignColumn")
vim.cmd("hi EndOfBuffer guifg=#1E1E1E")
vim.cmd("se cursorline")
vim.cmd("hi clear cursorline")

-- Highlights
vim.cmd([[
hi DiffAdd guibg=#1e1e1e guifg=green
hi DiffDelete guibg=#1e1e1e guifg=#cd3131
hi DiffChange guibg=#1e1e1e guifg=#bc3fbc
]])

--autocommands
vim.cmd(" augroup packer-sync \
		 	autocmd BufWritePost plugins.lua source <afile> | PackerCompile \
		 augroup END")

vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

vim.cmd("let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 0.4, 'yoffset': 1.0, 'border': 'horizontal' } }")
