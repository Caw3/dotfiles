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
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "vertical",
					layout_config = {
						vertical = { mirror = true, prompt_position = 'top', width = 120, preview_cutoff = 60, height = 40 }
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
			vim.keymap.set("n", "<leader>ft", builtin.tags)
			vim.keymap.set("n", "<leader>fp", function()
				builtin.git_files({
					previewer = false,
					layout_config = {
						vertical = { height = 20 }
					}

				})
			end)
			vim.keymap.set("n", "<leader>fr", builtin.registers)
		end,
	},
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
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
			{
				"nanotee/sqls.nvim",
				ft = "sql"
			},
		},
		config = function()
			local function populate_loclist()
				vim.diagnostic.setloclist({ open = false })
			end

			vim.api.nvim_create_autocmd("DiagnosticChanged", {
				callback = populate_loclist,
			})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					vim.diagnostic.config({
						virtual_text = false,
						signs = true,
						underline = true,
						severity_sort = true,
						update_in_insert = false
					})
					vim.lsp.completion.enable(true, event.data.client_id, event.buf,
						{ autotrigger = false })
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

					local border = {
						" ",
						" ",
						" ",
						" ",
						" ",
						" ",
						" ",
						" "
					}

					map("<c-s>",
						function()
							vim.lsp.buf.signature_help({
								focusable = true,
								max_width = 80,
								border =
								    border
							})
						end,
						"i")

					map("gh", vim.diagnostic.open_float)
					map("<leader>gd", require("telescope.builtin").lsp_definitions)
					map("^]", require("telescope.builtin").lsp_definitions)
					map("<leader>gR", require("telescope.builtin").lsp_references)
					map("<leader>gr", vim.lsp.buf.references)
					map("<leader>gI", require("telescope.builtin").lsp_implementations)
					map("<leader>gi", vim.lsp.buf.implementation)
					map("<leader>gt", require("telescope.builtin").lsp_type_definitions)
					map("<leader>@", require("telescope.builtin").lsp_document_symbols)
					map("<leader>#", require("telescope.builtin").lsp_workspace_symbols)
					map("<leader>rn", vim.lsp.buf.rename)
					map("<leader>ca", vim.lsp.buf.code_action, { "n", "x" })
					map("<leader>gD", vim.lsp.buf.declaration)
					map("<leader>oc", vim.lsp.buf.outgoing_calls)
					map("<leader>ic", vim.lsp.buf.outgoing_calls)
					map("<leader>K", function()
						local params = vim.lsp.util.make_position_params(0, 'utf-8')
						vim.lsp.buf_request(0, "textDocument/definition", params,
							function(err, result, ctx, _)
								if err or not result or vim.tbl_isempty(result) then
									return
								end
								-- Normalize single vs list results
								local location = vim.islist(result) and result[1] or
								    result
								-- location can be a Location or LocationLink
								local uri = location.uri or location.targetUri
								local range = location.range or
								    location.targetSelectionRange
								if not uri or not range then
									return
								end
								local path = vim.uri_to_fname(uri)
								vim.cmd("pedit " ..
									"+" ..
									range.start.line + 1 ..
									" " .. vim.fn.fnameescape(path))
							end)
					end)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.semanticTokensProvider then
						client.server_capabilities.semanticTokensProvider = nil
					end
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						client.server_capabilities.inlayHintProvider = nil
					end
				end,
			})

			local lspconfig = require('lspconfig')
			local function is_deno_project()
				local cwd = vim.fn.getcwd()
				return vim.fn.filereadable(cwd .. "/deno.json") == 1 or
				    vim.fn.filereadable(cwd .. "/deno.jsonc") == 1
			end

			if is_deno_project() then
				-- When in a Deno project, only enable denols.
				lspconfig.denols.setup {
					root_dir = lspconfig.util.root_pattern("deno.json", "deno.lock"),
					settings = {
						organizeImports = true,
					},
				}
			else
				-- Otherwise (non-Deno project) enable ts_ls.
				lspconfig.ts_ls.setup {
					root_dir = lspconfig.util.root_pattern("package.json", "yarn.lock"),
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

			local sqls_root_pattern = lspconfig.util.root_pattern(".sqls.yml")
			local sqls_root_dir = sqls_root_pattern(vim.fn.getcwd()) or vim.loop.cwd()

			lspconfig.sqls.setup {
				root_dir = sqls_root_pattern,
				cmd = {
					vim.fn.expand("$HOME/go/bin/sqls"),
					"-config",
					vim.fn.expand(sqls_root_dir .. "/.sqls.yml"),
				},
				on_attach = function(client, bufnr) require("sqls").on_attach(client, bufnr) end
			}
		end,
	},
	{
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
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
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
				"css",
				"javascript",
				"go",
				"java",
				"rust",
				"sql",
				"yaml",
				"json",
				"tsx",
			},
			auto_install = false,
			highlight = { enable = true, },
			disable = function(_lang, buf)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
			indent = { enable = true },
		},
	},
})
vim.cmd("source ~/.vimrc")
vim.o.undofile = true
vim.cmd("highlight! link NormalFloat Pmenu")
