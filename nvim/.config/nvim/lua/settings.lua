-- Settings
vim.o.shell = '/bin/zsh'
vim.cmd('set termguicolors')
vim.cmd('set scl=yes')

vim.cmd('set nu rnu')

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
vim.cmd('set nohlsearch')

vim.cmd('set nocompatible')
vim.cmd("filetype plugin indent on")
vim.cmd('set noshowmode')
vim.cmd('set noshowcmd')
vim.cmd('set shortmess+=F')

vim.g.jupytext_fmt = 'py:percent'
	
