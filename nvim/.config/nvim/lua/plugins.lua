-- Install Package manager if not found
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

return require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim" })

	--Autocompletion and Workflow
	use({ "tpope/vim-surround" })
	use({ "tpope/vim-commentary" })
	use({ "tpope/vim-endwise", ft = { "ruby", "lua", "haskell", "bash" } })
	use({ "L3MON4D3/LuaSnip" })
	use({ "rafamadriz/friendly-snippets", config = [[require('config.snippets')]], after = "LuaSnip" })
	-- CMP
	use({ "hrsh7th/nvim-cmp", config = [[require('config.cmp')]] })
	use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
	use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" })
	use({ "windwp/nvim-autopairs", config = [[require('config.autopairs')]], after = "nvim-cmp" })

	--LSP
	use({ "neovim/nvim-lspconfig" })
	use({ "williamboman/nvim-lsp-installer" })
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = [[require('lsp.null-ls')]],
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	--Treesitter
	use({ "nvim-treesitter/nvim-treesitter", config = [[require('config.treesitter')]], run = ":TSUpdate" })

	--Cosmetic
	use({ "nvim-lualine/lualine.nvim", config = [[require('config.lualine')]] })
	use({ "tomasiser/vim-code-dark" })
	use({ "norcalli/nvim-colorizer.lua", config = [[require('config.colorizer')]] })

	--File navigation
	use({
		"junegunn/fzf",
		run = function()
			vim.fn["fzf#install"]()
		end,
	})
	use({ "junegunn/fzf.vim" })
	use({ "christoomey/vim-tmux-navigator" })
	use({ "elihunter173/dirbuf.nvim" })
	use({
		"nvim-telescope/telescope.nvim",
		config = [[require('config.telescope')]],
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "airblade/vim-rooter" })

	--Git wrapper
	use({ "tpope/vim-fugitive" })
	use({
		"lewis6991/gitsigns.nvim",
		config = [[require('config.gitsigns')]],
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	--Filetypes
	use({ "lervag/vimtex", ft = { "tex" } })
	use({ "kdheepak/cmp-latex-symbols", ft = { "tex" }, after = "nvim-cmp" })
	-- use({ "goerz/jupytext.vim", config = [[require('config.ipynb')]] })
	-- use({ "bfredl/nvim-ipy", ft = { "python" } })

	--Profiler
	-- use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })

	if packer_bootstrap then
		require("packer").sync()
	end
end)
