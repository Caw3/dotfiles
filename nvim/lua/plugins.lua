--Install Package manager if not found
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	--Autocompletion and Workflow
	use 'raimondi/delimitmate'
	use 'tpope/vim-commentary'
	use 'tpope/vim-surround'
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
	-- CMP
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/cmp-nvim-lsp'
	--LSP
	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'

	--Treesitter
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
    }
	--Cosmetic
	use 'lifepillar/vim-gruvbox8'
	use	'nvim-lualine/lualine.nvim'
	use 'tomasiser/vim-code-dark'

	--File navigation
	use 'kyazdani42/nvim-tree.lua'
	use 'ahmedkhalf/project.nvim'
	use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/plenary.nvim'}}}
	use {'nvim-telescope/telescope-fzf-native.nvim', run='make' }
	use 'seblj/nvim-tabline'

	--Git wrapper
	use 'tpope/vim-fugitive'

	--Filetypes
	use 'lervag/vimtex'

	--Profiler
	use 'tweekmonster/startuptime.vim'

	if packer_bootstrap then
		require('packer').sync()
	end
end)

