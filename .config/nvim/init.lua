vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.cmd("filetype plugin indent on")
vim.opt.autoread = true
vim.opt.mouse = "a"
vim.opt.ttyfast = true
vim.opt.wildmenu = true
vim.opt.wildoptions = "fuzzy,tagfile"
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.backspace = "indent,eol,start"
vim.opt.updatetime = 100
vim.opt.completeopt = "fuzzy,menuone,popup"
vim.opt.pumheight = 40
vim.opt.wildignore = "*.o,node_modules/**,dist/**,build/**"
vim.opt.path = "src/,apps/,libs/,test/,e2e/,cmd/,utils/"
vim.opt.undofile = true
vim.opt.fillchars = "vert:│,stl:―,stlnc:―"
vim.opt.laststatus = 0
vim.opt.termguicolors = false
vim.opt.grepprg = "rg --vimgrep --hidden --iglob=!.git/*"

vim.keymap.set("n", "<leader>*", ":Grep <C-R><C-W><CR>", { silent = true })
vim.keymap.set("n", "<leader>/", ":Grep ")
vim.keymap.set("x", "<leader>*", "\"vy:Grep -F <C-r>=shellescape(@v)<CR><CR>")

vim.keymap.set("i", "{<CR>", "{<CR>}<C-o>O")
vim.keymap.set("n", "<leader>nn", "<cmd>set nu!<CR>")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>s", ":%s//g<Left><Left>")
vim.keymap.set("v", "<leader>s", ":s//g<Left><Left>")
vim.keymap.set("x", "*", "\"vy/\\V<C-r>=escape(@v,'/\\')<CR><CR>")
vim.keymap.set("n", "<leader>ff", ":find **/*")
vim.keymap.set("n", "<leader>fq", ":Findqf ")
vim.keymap.set("n", "<leader>fe", ":edit **/*")
vim.keymap.set("n", "<leader>tt", ":tag ")

vim.keymap.set("n", "<leader>co", "<cmd>copen<CR>")
vim.keymap.set("n", "<leader>cc", "<cmd>cclose<CR>")
vim.keymap.set("n", "]q", "<cmd>cnext<CR>")
vim.keymap.set("n", "[q", "<cmd>cprev<CR>")
vim.keymap.set("n", "]Q", "<cmd>clast<CR>")
vim.keymap.set("n", "[Q", "<cmd>cfirst<CR>")

vim.keymap.set("n", "<leader>lo", "<cmd>lopen<CR>")
vim.keymap.set("n", "<leader>lc", "<cmd>lclose<CR>")
vim.keymap.set("n", "]l", "<cmd>lnext<CR>")
vim.keymap.set("n", "[l", "<cmd>lprev<CR>")
vim.keymap.set("n", "]L", "<cmd>llast<CR>")
vim.keymap.set("n", "[L", "<cmd>lfirst<CR>")

vim.keymap.set("n", "]t", "<cmd>tnext<CR>")
vim.keymap.set("n", "[t", "<cmd>tprev<CR>")

-- Grep function using ripgrep
local function grep(...)
	local args = { ... }
	for i, arg in ipairs(args) do
		args[i] = vim.fn.expand(arg)
	end
	local command = vim.o.grepprg .. " " .. table.concat(args, " ")
	return vim.fn.system(command)
end

vim.api.nvim_create_user_command("Grep", function(opts)
	vim.fn.setqflist({}, " ", { title = "Grep", lines = vim.split(grep(opts.args), "\n") })
	vim.cmd("cwindow")
end, { nargs = "+", complete = "file_in_path" })

local function fd_set_quickfix(...)
	local args = { ... }
	local fdresults = vim.fn.systemlist("fd -t f --hidden " .. table.concat(args, " "))
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_err_writeln("Fd error: " .. (fdresults[1] or "unknown error"))
		return
	end
	local qflist = {}
	for _, val in ipairs(fdresults) do
		table.insert(qflist, { filename = val, lnum = 1, text = val })
	end
	vim.fn.setqflist(qflist)
	vim.cmd("copen")
end

vim.api.nvim_create_user_command("Findqf", function(opts)
	fd_set_quickfix(opts.args)
end, { nargs = "+", complete = "file_in_path" })


local function find_git_files(cmdarg, _cmdcomplete)
	local fnames = vim.fn.systemlist("git ls-files")
	return vim.tbl_filter(function(v)
		return v:lower():find(cmdarg:lower())
	end, fnames)
end

if vim.fn.system("git rev-parse --is-inside-work-tree"):match("^true") then
	vim.opt.findfunc = "v:lua.FindGitFiles"
	_G.FindGitFiles = find_git_files
end

-- Quickfix autocommands
local quickfix_group = vim.api.nvim_create_augroup("quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = quickfix_group,
	pattern = "qf",
	callback = function()
		vim.opt_local.wrap = true
	end,
})

local check_update_timer = nil
local function check_update()
	vim.cmd("silent! checktime")
end

if not check_update_timer then
	check_update_timer = vim.uv.new_timer()
	check_update_timer:start(vim.o.updatetime, vim.o.updatetime, vim.schedule_wrap(check_update))
end

vim.cmd("packadd cfilter")
vim.cmd("packadd termdebug")
vim.g.termdebug_wide = 1

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
	{
		"tpope/vim-dispatch",
		config = function()
			local map = vim.keymap.set
			map("n", "<Leader>mm", "<cmd>Make<cr>")
			map("n", "<Leader>mM", ":Make ")
			map("n", "<Leader>md", ":Dispatch -compiler=")
		end,
	},
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
	'shumphrey/fugitive-gitlab.vim',
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
			local hl = vim.api.nvim_set_hl
			hl(0, "VertSplit", { link = "LineNr" })
			hl(0, "WinSeparator", { link = "LineNr" })
			hl(0, "IncSearch", { link = "LineNr" })
			hl(0, "StatusLineNC", { link = "LineNr" })
			hl(0, "StatusLine", { link = "LineNr" })
			hl(0, "StatusLineTermNC", { link = "LineNr" })
			hl(0, "StatusLineTerm", { link = "LineNr" })
			hl(0, "debugPC", { link = "Visual" })
			hl(0, "debugBreakpoint", { link = "TODO" })
			hl(0, "QuickFixLine", { link = "Visual" })
			hl(0, "qfError", { link = "Number" })
			hl(0, "qfFilename", { link = "Conditional" })
			hl(0, "NormalFloat", { link = "Pmenu" })
			hl(0, "Visual", { link = "CursorLine" })
			hl(0, "Search", { ctermfg = 6, ctermbg = 8 })
			hl(0, "CurSearch", { ctermfg = 5, ctermbg = 8 })
		end,
	},
	{
		"airblade/vim-gitgutter",
		init = function()
			vim.g.gitgutter_show_msg_on_hunk_jumping = 1
			vim.g.gitgutter_sign_added = "│"
			vim.g.gitgutter_sign_modified = "│"
			vim.g.gitgutter_sign_removed = "│"
			vim.g.gitgutter_preview_win_floating = false
		end,
		config = function()
			vim.keymap.set("n", "<leader>ghs", "<plug>(GitGutterStageHunk)",
				{ desc = "GitGutter stage hunk" })
			vim.keymap.set("n", "<leader>ghu", "<plug>(GitGutterUndoHunk)", { desc = "GitGutter undo hunk" })
			vim.keymap.set("n", "<leader>ghp", "<plug>(GitGutterPreviewHunk)",
				{ desc = "GitGutter preview hunk" })
			vim.keymap.set("n", "<leader>ght", "<cmd>GitGutterToggle<CR>", { desc = "Toggle GitGutter" })

			vim.keymap.set("o", "ih", "<plug>(GitGutterTextObjectInnerPending)", { silent = true })
			vim.keymap.set("x", "ih", "<plug>(GitGutterTextObjectInnerVisual)", { silent = true })
			vim.keymap.set("o", "ah", "<plug>(GitGutterTextObjectOuterPending)", { silent = true })
			vim.keymap.set("x", "ah", "<plug>(GitGutterTextObjectOuterVisual)", { silent = true })
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
			vim.keymap.set("n", "<leader>fg", builtin.live_grep)
			vim.keymap.set("n", "<leader>fs", builtin.find_files)
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
		},
		config = function()
			-- Helper to ensure LSP is running before calling LSP function
			local function with_lsp(fn)
				return function()
					local bufnr = vim.api.nvim_get_current_buf()
					local clients = vim.lsp.get_clients({ bufnr = bufnr })
					if #clients == 0 then
						vim.cmd("LspStart")
						vim.api.nvim_create_autocmd("LspAttach", {
							buffer = bufnr,
							once = true,
							callback = vim.schedule_wrap(fn),
						})
					else
						fn()
					end
				end
			end

			local function populate_loclist()
				vim.diagnostic.setloclist({ open = false })
			end

			vim.api.nvim_create_autocmd("DiagnosticChanged", {
				callback = populate_loclist,
			})

			-- Diagnostic config (global)
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				severity_sort = true,
				update_in_insert = false
			})

			-- Global LSP keymaps (will start LSP if needed)
			local lsp_enabled = false
			local function toggle_all_lsps()
				if lsp_enabled then
					for _, client in pairs(vim.lsp.get_clients()) do
						client.stop()
					end
					vim.notify("All LSPs stopped", vim.log.levels.INFO)
				else
					vim.cmd("LspStart")
					vim.api.nvim_create_autocmd("LspAttach", {
						buffer = 0,
						once = true,
						callback = function()
							vim.notify("LSP started", vim.log.levels.INFO)
						end,
					})
				end
				lsp_enabled = not lsp_enabled
			end

			local border = { " ", " ", " ", " ", " ", " ", " ", " " }

			vim.keymap.set("n", "<leader>ds", toggle_all_lsps, { desc = "Toggle all LSPs" })
			vim.keymap.set("n", "<leader>rr", "<cmd>e! %<CR>", { desc = "Reload file" })
			vim.keymap.set("n", "]e", vim.diagnostic.goto_next, { noremap = true, silent = true })
			vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, { noremap = true, silent = true })
			vim.keymap.set("n", "gh", vim.diagnostic.open_float)

			vim.keymap.set("i", "<c-h>", with_lsp(function()
				vim.lsp.buf.signature_help({ focusable = true, max_width = 80, border = border })
			end))

			vim.keymap.set("n", "<C-]>", function()
				local ok = pcall(vim.cmd, "tag " .. vim.fn.expand("<cword>"))
				if not ok then
					with_lsp(vim.lsp.buf.definition)()
				end
			end, { desc = "Tag or LSP definition" })
			vim.keymap.set("n", "<leader>gD", with_lsp(vim.lsp.buf.declaration))
			vim.keymap.set("n", "<leader>gd", with_lsp(vim.lsp.buf.definition))
			vim.keymap.set("n", "<leader>gR", with_lsp(function()
				require("telescope.builtin").lsp_references()
			end))
			vim.keymap.set("n", "<leader>gr", with_lsp(vim.lsp.buf.references))
			vim.keymap.set("n", "<leader>gI", with_lsp(function()
				require("telescope.builtin").lsp_implementations()
			end))
			vim.keymap.set("n", "<leader>gi", with_lsp(vim.lsp.buf.implementation))
			vim.keymap.set("n", "<leader>gt", with_lsp(vim.lsp.buf.type_definition))
			vim.keymap.set("n", "<leader>@", with_lsp(function()
				require("telescope.builtin").lsp_document_symbols()
			end))
			vim.keymap.set("n", "<leader>#", with_lsp(function()
				local query = vim.fn.input("#")
				if query == "" then
					return
				end
				require("telescope.builtin").lsp_workspace_symbols({ query = query })
			end))
			vim.keymap.set("n", "<leader>rn", with_lsp(vim.lsp.buf.rename))
			vim.keymap.set({ "n", "x" }, "<leader>ca", with_lsp(vim.lsp.buf.code_action))
			vim.keymap.set("n", "<leader>oc", with_lsp(vim.lsp.buf.outgoing_calls))
			vim.keymap.set("n", "<leader>ic", with_lsp(vim.lsp.buf.incoming_calls))
			vim.keymap.set("n", "<leader>gp", with_lsp(function()
				local params = vim.lsp.util.make_position_params(0, 'utf-8')
				vim.lsp.buf_request(0, "textDocument/definition", params,
					function(err, result, ctx, _)
						if err or not result or vim.tbl_isempty(result) then
							return
						end
						local location = vim.islist(result) and result[1] or result
						local uri = location.uri or location.targetUri
						local range = location.range or location.targetSelectionRange
						if not uri or not range then
							return
						end
						local path = vim.uri_to_fname(uri)
						vim.cmd("pedit +" ..
						range.start.line + 1 .. " " .. vim.fn.fnameescape(path))
					end)
			end))

			-- LspAttach for buffer-local setup
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					vim.lsp.completion.enable(true, event.data.client_id, event.buf,
						{ autotrigger = false })

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.semanticTokensProvider then
						client.server_capabilities.semanticTokensProvider = nil
					end
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						client.server_capabilities.inlayHintProvider = nil
					end
					if client and client.supports_method(vim.lsp.protocol.Methods.workspaceSymbol_resolve) then
						vim.keymap.set("n", "<leader>#",
							require("telescope.builtin").lsp_dynamic_workspace_symbols,
							{ buffer = event.buf })
					end
				end,
			})

			local function is_deno_project()
				local cwd = vim.fn.getcwd()
				return vim.fn.filereadable(cwd .. "/deno.json") == 1 or
				    vim.fn.filereadable(cwd .. "/deno.jsonc") == 1
			end

			if is_deno_project() then
				vim.lsp.config("denols", {
					settings = {
						organizeImports = true,
					},
				})
			else
				vim.lsp.config("ts_ls", {
					settings = {
						organizeImports = true,
					},
				})
			end
			vim.lsp.config("lua_ls", {})
			vim.lsp.config("clangd", {})
			vim.lsp.config("gopls", {})
			vim.lsp.config("pyright", {})
			vim.lsp.config("rust_analyzer", {})
			vim.lsp.config("terraformls", {})
			vim.lsp.config("bashls", {})
			vim.lsp.config("jdtls", {})
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
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		main = "nvim-treesitter.configs",
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
			vim.keymap.set("n", "<leader>ts", function()
				if vim.b.ts_highlight then
					vim.treesitter.stop()
					vim.notify("Treesitter disabled", vim.log.levels.INFO)
				else
					vim.treesitter.start()
					vim.notify("Treesitter enabled", vim.log.levels.INFO)
				end
			end, { desc = "Toggle treesitter" })
		end,
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
			highlight = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			disable = function(_lang, buf)
				local max_filesize = 1000 * 1000 * 1024 -- 1 MB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
			indent = { enable = true },
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["ao"] = "@call.outer",
						["io"] = "@call.inner",
						["a/"] = "@comment.outer",
						["i/"] = "@comment.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]gf"] = "@function.outer",
						["]gc"] = "@class.outer",
						["]ga"] = "@parameter.inner",
						["]gi"] = "@conditional.outer",
						["]go"] = "@call.outer",
						["]gl"] = "@loop.outer",
						["]g/"] = "@comment.outer",
					},
					goto_next_end = {
						["]gF"] = "@function.outer",
						["]gC"] = "@class.outer",
						["]gA"] = "@parameter.inner",
						["]gI"] = "@conditional.outer",
						["]gL"] = "@loop.outer",
						["]gO"] = "@call.outer",
						["]g?"] = "@comment.outer",
					},
					goto_previous_start = {
						["[gf"] = "@function.outer",
						["[gc"] = "@class.outer",
						["[ga"] = "@parameter.inner",
						["[gi"] = "@conditional.outer",
						["[gl"] = "@loop.outer",
						["[go"] = "@call.outer",
						["[g/"] = "@comment.outer",
					},
					goto_previous_end = {
						["[gF"] = "@function.outer",
						["[gC"] = "@class.outer",
						["[gA"] = "@parameter.inner",
						["[gI"] = "@conditional.outer",
						["[gL"] = "@loop.outer",
						["[gO"] = "@call.outer",
						["[g?"] = "@comment.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["gsa"] = "@parameter.inner",
					},
					swap_previous = {
						["gsA"] = "@parameter.inner",
					},
				},
			},
		},
	},
})

local ft_group = vim.api.nvim_create_augroup("filetypes", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = ft_group,
	pattern = "javascript",
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = ft_group,
	pattern = "typescript",
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = ft_group,
	pattern = "css",
	callback = function()
		vim.opt_local.omnifunc = "csscomplete#CompleteCSS"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = ft_group,
	pattern = "markdown",
	callback = function()
		vim.opt_local.textwidth = 80
		vim.opt_local.expandtab = false
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us,sv"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = ft_group,
	pattern = "sh",
	callback = function()
		vim.cmd("compiler shellcheck")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = ft_group,
	pattern = "tex",
	callback = function()
		vim.g.tex_flavor = "latex"
		vim.g.vimtex_fold_enabled = 1
		vim.g.vimtex_quickfix_mode = 0
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en,sv"
	end,
})
