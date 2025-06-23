-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.cmd("source ~/.vimrc")

require("lazy").setup({
	"tpope/vim-sleuth",
	"tpope/vim-vinegar",
	"tpope/vim-dispatch",
	"tpope/vim-surround",
	"romainl/vim-qf",
	{
		"github/copilot.vim", cmd = "Copilot",

	},
	{
		"romainl/vim-cool",
		config = function()
			vim.g.cool_total_matches = 1
		end,
	},
	{
		"tpope/vim-fugitive",
		config = function()
			-- Set autocommands for Fugitive filetype
			vim.api.nvim_create_augroup("ft_fugitive", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = "ft_fugitive",
				pattern = "fugitive",
				callback = function()
					vim.opt_local.signcolumn = "yes"
					vim.opt_local.number = false
				end,
			})

			-- Define key mappings
			local map = vim.keymap.set
			local opts = { noremap = true, silent = true }

			map("n", "<Leader>gs", ":vert Git | vertical resize 80<CR>", opts)
			map("n", "<Leader>gb", ":G blame<CR>", opts)
			map("n", "<Leader>gl", ":Gclog<CR>", opts)
			map(
				"v",
				"<Leader>gl",
				"<ESC>:execute 'vert G log -L' . line(\"'<\") . ',' . line(\"'>\") . ':' . expand('%') <CR>"
			)
			map("n", "<Leader>gv", ":Gvdiffsplit<CR>", opts)
			map("n", "<Leader>gV", ":Gvdiffsplit!<CR>", opts)
			map("n", "<Leader>gm", ":G mergetool<CR>", opts)
			map("n", "dgh", ":diffget //2<CR>", opts)
			map("n", "dgl", ":diffget //3<CR>", opts)
		end,
	},
	{
		"arcticicestudio/nord-vim",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme nord")
		end,
	},
	{
		"mhinz/vim-signify",
		init = function()
			vim.g.signify_sign_change = "│"
			vim.g.signify_sign_add = "│"
			vim.g.signify_sign_delete = "│"
		end,
		config = function()
			-- Keymaps
			vim.keymap.set("n", "<leader>ghp", "<cmd>SignifyHunkDiff<CR>", { desc = "Signify hunk diff" })
			vim.keymap.set("n", "<leader>ghu", "<cmd>SignifyHunkUndo<CR>", { desc = "Signify hunk undo" })
			vim.keymap.set("n", "<leader>ght", "<cmd>SignifyToggle<CR>", { desc = "Toggle Signify " })

			-- Motions
			vim.keymap.set("o", "ic", "<plug>(signify-motion-inner-pending)", { silent = true })
			vim.keymap.set("x", "ic", "<plug>(signify-motion-inner-visual)", { silent = true })
			vim.keymap.set("o", "ac", "<plug>(signify-motion-outer-pending)", { silent = true })
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "vertical",
					layout_config = {
						vertical = { width = 120, heigth = 60, preview_cutoff = 40 }
					},
					mappings = {
						i = {
							['<c-enter>'] = 'to_fuzzy_refine',
							["<C-q>"] = require("telescope.actions").smart_send_to_qflist +
							    require("telescope.actions").open_qflist
						}
					}
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files)
			vim.keymap.set("n", "<leader>ft", builtin.tags)
			vim.keymap.set("n", "<leader>fp", builtin.git_files)
			vim.keymap.set("n", "<leader>fr", builtin.registers)
		end,
	},
	-- LSP Plugins
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local lsp_enabled = true

					local function toggle_all_lsps()
						if lsp_enabled then
							for _, client in pairs(vim.lsp.get_active_clients()) do
								client.stop()
							end
							vim.notify("All LSPs stopped", vim.log.levels.INFO)
						else
							vim.cmd("edit")
							vim.notify("All LSPs restarted", vim.log.levels.INFO)
						end
						lsp_enabled = not lsp_enabled
					end

					vim.keymap.set("n", "<leader>ds", toggle_all_lsps, { desc = "Toggle all LSPs" })

					local map = function(keys, func, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf })
					end

					vim.keymap.set("n", "]e", vim.diagnostic.goto_next,
						{ noremap = true, silent = true })
					vim.keymap.set("n", "[e", vim.diagnostic.goto_prev,
						{ noremap = true, silent = true })

					map("di", vim.diagnostic.open_float)
					map("gd", require("telescope.builtin").lsp_definitions)
					map("^]", require("telescope.builtin").lsp_definitions)
					map("gR", require("telescope.builtin").lsp_references)
					map("gr", vim.lsp.buf.references)
					map("gI", require("telescope.builtin").lsp_implementations)
					map("gI", vim.lsp.buf.implementation)
					map("<leader>gt", require("telescope.builtin").lsp_type_definitions)
					map("<leader>@", require("telescope.builtin").lsp_document_symbols)
					map("<leader>#", require("telescope.builtin").lsp_dynamic_workspace_symbols)
					map("<leader>rn", vim.lsp.buf.rename)
					map("<leader>ca", vim.lsp.buf.code_action, { "n", "x" })
					map("gD", vim.lsp.buf.declaration)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
						    vim.api.nvim_create_augroup("kickstart-lsp-highlight",
							    { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach",
								{ clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({
									group =
									"kickstart-lsp-highlight",
									buffer = event2.buf
								})
							end,
						})
					end

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
								bufnr =
								    event.buf
							}))
						end)
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities,
				require("blink.cmp").get_lsp_capabilities())

			local lspconfig = require('lspconfig')
			local function is_deno_project()
				local cwd = vim.fn.getcwd()
				return vim.fn.filereadable(cwd .. "/deno.json") == 1 or
				    vim.fn.filereadable(cwd .. "/deno.jsonc") == 1
			end

			if is_deno_project() then
				-- When in a Deno project, only enable denols.
				lspconfig.denols.setup {
					settings = {
						organizeImports = true,
					},
				}
			else
				-- Otherwise (non-Deno project) enable ts_ls.
				lspconfig.ts_ls.setup {
					settings = {
						organizeImports = true,
					},
				}
			end
			lspconfig.lua_ls.setup {}
			lspconfig.clangd.setup {}
			lspconfig.gopls.setup {}
			lspconfig.pyright.setup {}
			lspconfig.rust_analyzer.setup {}
			lspconfig.terraformls.setup {}
			lspconfig.bashls.setup {}
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cr",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},
	{
		"saghen/blink.cmp",
		version = "*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			fuzzy = {
				implementation = "lua"
			},
			keymap = {
				preset = "enter",
			},
			cmdline = {
				enabled = false,
			},

			appearance = {
				kind_icons = {},
			},
			sources = {
				default = { "lsp" },
			},
			signature = {
				enabled = true,
				window = {
					treesitter_highlighting = true,
				},
			},
			completion = {
				accept = { auto_brackets = { enabled = false }, },
				menu = {
					auto_show = false,
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind" },
						},
					},
				},
				documentation = { auto_show = true, treesitter_highlighting = true },
			},
		},
		opts_extend = { "sources.default" },
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"typescript",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = { enable = true, disable = { "ruby" } },
		},
	},
})
vim.o.undofile = true
vim.cmd("highlight! link NormalFloat Pmenu")
