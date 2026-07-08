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
vim.keymap.set("n", "<leader>s", ":%s//g<Left><Left>")
vim.keymap.set("v", "<leader>s", ":s//g<Left><Left>")
vim.keymap.set("x", "*", "\"vy/\\V<C-r>=escape(@v,'/\\')<CR><CR>")
vim.keymap.set("n", "<leader>ff", ":find **/*")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

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

local function _fname(bufnr) return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr or 0), ":.") end
local function _copy_loc()
	local c = vim.api.nvim_win_get_cursor(0)
	vim.fn.setreg("+", string.format("%s:%d:%d", _fname(), c[1], c[2] + 1))
end
local function _copy_visual()
	local v, c = vim.fn.getpos("v"), vim.fn.getpos(".")
	local s, e = v[2], c[2]
	if s > e then s, e = e, s end
	vim.fn.setreg("+", string.format("%s:%d-%d", _fname(), s, e))
end
local function _copy_qf()
	local q = vim.fn.getqflist()
	if #q == 0 then return end
	local t = {}
	for _, i in ipairs(q) do
		t[#t + 1] = string.format("%s:%d:%d: %s", _fname(i.bufnr), i.lnum or 0, i.col or 0, i.text or "")
	end
	vim.fn.setreg("+", table.concat(t, "\n"))
end
local function _copy_ll()
	local q = vim.fn.getloclist(0)
	if #q == 0 then return end
	local t = {}
	for _, i in ipairs(q) do
		t[#t + 1] = string.format("%s:%d:%d: %s", _fname(i.bufnr), i.lnum or 0, i.col or 0, i.text or "")
	end
	vim.fn.setreg("+", table.concat(t, "\n"))
end

vim.keymap.set("n", "<leader>yf", _copy_loc, { desc = "Copy file:line:col" })
vim.keymap.set("x", "<leader>yf", _copy_visual, { desc = "Copy file line range" })
vim.keymap.set("n", "<leader>yg", "<cmd>.GBrowse!<CR>", { desc = "Copy Git URL for current line" })
vim.keymap.set("n", "<leader>yq", _copy_qf, { desc = "Copy quickfix list" })
vim.keymap.set("n", "<leader>yl", _copy_ll, { desc = "Copy local list" })
vim.keymap.set("n", "<leader>rr", "<cmd>e! %<CR>", { desc = "Reload file" })

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

local function find_git_files(cmdarg, _)
	local fnames = vim.fn.systemlist("git ls-files")
	return vim.tbl_filter(function(v)
		return vim.fn.match(v, cmdarg) ~= -1
	end, fnames)
end

if vim.fn.system("git rev-parse --is-inside-work-tree"):match("^true") then
	vim.opt.findfunc = "v:lua.FindGitFiles"
	_G.FindGitFiles = find_git_files
end

local check_update_timer = nil
local function check_update()
	vim.cmd("silent! checktime")
end

if not check_update_timer then
	check_update_timer = vim.uv.new_timer()
	check_update_timer:start(vim.o.updatetime, vim.o.updatetime, vim.schedule_wrap(check_update))
end

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
			vim.keymap.set("n", "<Leader>mm", "<cmd>Make<cr>")
			vim.keymap.set("n", "<Leader>mM", ":Make ")
			vim.keymap.set("n", "<Leader>md", ":Dispatch -compiler=")
		end,
	},
	"tpope/vim-surround",
	"romainl/vim-qf",
	"romainl/vim-cool",
	{
		"tpope/vim-rhubarb",
		config = function()
			vim.g.github_enterprise_urls = { "https://spotify.ghe.com" }
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

			local opts = { noremap = true, silent = true }

			vim.keymap.set("n", "<Leader>gs", ":vert Git | vertical resize 80<CR>", opts)
			vim.keymap.set("n", "<Leader>gb", ":G blame<CR>", opts)
			vim.keymap.set("n", "<Leader>gl", ":Gclog<CR>", opts)
			vim.keymap.set(
				"v",
				"<Leader>gl",
				"<ESC>:execute 'vert G log -L' . line(\"'<\") . ',' . line(\"'>\") . ':' . expand('%') <CR>"
			)
			vim.keymap.set("n", "<Leader>gv", ":Gvdiffsplit<CR>", opts)
			vim.keymap.set("n", "<Leader>gV", ":Gvdiffsplit!<CR>", opts)
			vim.keymap.set("n", "<Leader>gm", ":G mergetool<CR>", opts)
			vim.keymap.set("n", "dgh", ":diffget //2<CR>", opts)
			vim.keymap.set("n", "dgl", ":diffget //3<CR>", opts)
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
			hl(0, "IncSearch", { link = "Search" })
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

			vim.api.nvim_create_autocmd("FocusGained", {
				group = checktime_group,
				callback = function()
					if vim.fn.exists(":GitGutter") == 2 then
						vim.cmd("silent! GitGutter")
					end
				end,
			})

			vim.api.nvim_create_autocmd("FileChangedShellPost", {
				group = checktime_group,
				callback = function()
					if vim.fn.exists(":GitGutter") == 2 then
						vim.cmd("silent! GitGutter")
					end
				end,
			})

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
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				severity_sort = true,
				update_in_insert = false,
			})

			vim.keymap.set("n", "gh", vim.diagnostic.open_float)
			vim.keymap.set("n", "<leader>dl", function()
				vim.diagnostic.setloclist({ open = true })
			end, { desc = "Diagnostics → location list" })

			local lsps = {
				(vim.fn.filereadable(vim.fn.getcwd() .. "/deno.json") == 1 and
					{ "denols", { settings = { organizeImports = true } } } or
					{ "ts_ls", { settings = { organizeImports = true }, init_options = { maxTsServerMemory = 8192 } } }),
				{ "lua_ls" },
				{ "clangd" },
				{ "gopls" },
				{ "pyright" },
				{ "rust_analyzer" },
				{ "terraformls" },
				{ "bashls" },
				{ "jdtls" },
				{ "postgres_lsp" },
				{ "buf_ls" },
			}
			local lsp_server_names = {}
			for _, entry in ipairs(lsps) do
				local name, opts = entry[1], entry[2]
				table.insert(lsp_server_names, name)
				if opts then
					vim.lsp.config(name, opts)
				end
			end

			local lsp_enabled = false


			local function with_lazy_lsp(fn)
				local function lsp_ensure_workspace()
					if lsp_enabled then
						return
					end
					lsp_enabled = true
					for _, name in ipairs(lsp_server_names) do
						vim.lsp.enable(name, true)
					end
				end
				return function()
					local bufnr = vim.api.nvim_get_current_buf()
					if #vim.lsp.get_clients({ bufnr = bufnr }) > 0 then
						return fn()
					end
					lsp_ensure_workspace()
					if #vim.lsp.get_clients({ bufnr = bufnr }) > 0 then
						return fn()
					end
					vim.api.nvim_create_autocmd("LspTokenUpdate", {
						buffer = bufnr,
						once = true,
						callback = function()
							vim.schedule(fn)
						end,
					})
				end
			end

			for _, name in ipairs(lsp_server_names) do
				vim.lsp.enable(name, false)
			end

			vim.keymap.set("n", "<C-]>", with_lazy_lsp(vim.lsp.buf.definition), { desc = "LSP definition" })
			vim.keymap.set("n", "<leader>gD", with_lazy_lsp(vim.lsp.buf.declaration))
			vim.keymap.set("n", "<leader>gd", with_lazy_lsp(vim.lsp.buf.definition))
			vim.keymap.set("n", "<leader>gr", with_lazy_lsp(vim.lsp.buf.references))
			vim.keymap.set("n", "<leader>gI", with_lazy_lsp(function()
				require("telescope.builtin").lsp_implementations()
			end))
			vim.keymap.set("n", "<leader>K", with_lazy_lsp(vim.lsp.buf.hover))
			vim.keymap.set("n", "<leader>gi", with_lazy_lsp(vim.lsp.buf.implementation))
			vim.keymap.set("n", "<leader>gt", with_lazy_lsp(vim.lsp.buf.type_definition))
			vim.keymap.set("n", "<leader>@", with_lazy_lsp(vim.lsp.buf.document_symbol))
			vim.keymap.set("n", "<leader>#", with_lazy_lsp(function()
				local query = vim.fn.input("#")
				if query ~= "" then
					vim.lsp.buf.workspace_symbol(query)
				end
			end))
			vim.keymap.set("n", "<leader>rn", with_lazy_lsp(vim.lsp.buf.rename))
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
			vim.keymap.set("x", "<leader>ca", vim.lsp.buf.code_action)
			vim.keymap.set("n", "<leader>cr", with_lazy_lsp(function()
				vim.lsp.buf.format({ async = true })
			end), { desc = "LSP format buffer" })
			vim.keymap.set("n", "<leader>oc", with_lazy_lsp(vim.lsp.buf.outgoing_calls))
			vim.keymap.set("n", "<leader>ic", with_lazy_lsp(vim.lsp.buf.incoming_calls))

			vim.keymap.set("n", "<leader>ds", function()
				lsp_enabled = not lsp_enabled
				for _, name in ipairs(lsp_server_names) do
					vim.lsp.enable(name, lsp_enabled)
				end
				if not lsp_enabled then
					for _, client in ipairs(vim.lsp.get_clients()) do
						client:stop(true)
					end
				end
				vim.notify("LSP " .. (lsp_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
			end, { desc = "LSP: stop/start globally" })
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
			vim.keymap.set("n", "<leader>%", builtin.live_grep)
			vim.keymap.set("n", "<leader>fs", builtin.find_files)
			vim.keymap.set("n", "<leader>f#", builtin.lsp_dynamic_workspace_symbols)
		end,
	},
})

local ft_group = vim.api.nvim_create_augroup("filetypes", { clear = true })

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
