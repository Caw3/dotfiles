--Wrapper Functions
local function map(mode, shortcut, command)
	vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
	map("n", shortcut, command)
end

local function omap(shortcut, command)
	map("i", shortcut, command)
end

local function imap(shortcut, command)
	map("i", shortcut, command)
end

local function vmap(shortcut, command)
	map("v", shortcut, command)
end

local function cmap(shortcut, command)
	map("c", shortcut, command)
end

local function tmap(shortcut, command)
	map("t", shortcut, command)
end

local function xmap(shortcut, command)
	map("x", shortcut, command)
end
--Keybinds

vim.g.mapleader = " "
--Tab navigation

nmap("<leader>1", "1gt")
nmap("<leader>2", "2gt")
nmap("<leader>3", "3gt")
nmap("<leader>4", "4gt")
nmap("<leader>5", "5gt")
nmap("<leader>6", "6gt")
nmap("<leader>7", "7gt")
nmap("<leader>8", "8gt")

nmap("<leader><tab>n", ":tabnew <CR>")
nmap("<leader><tab>c", ":tabclose <CR>")
nmap("<leader><tab>o", ":tabo <CR>")
nmap("<leader><tab>r", "<cmd>lua require('tabline.actions').set_tabname()<CR>")

--Buffer movement
nmap("<leader>l", "<c-w>l")
nmap("<leader>h", "<c-w>h")
nmap("<leader>k", "<c-w>k")
nmap("<leader>j", "<c-w>j")
nmap("<leader>wq", "<c-w>q")
nmap("<leader>wv", "<c-w>v")
nmap("<leader>ws", "<c-w>s")
nmap("<leader>wx", "<c-w>x")
nmap("<leader>we", "<c-w>=")
nmap("<leader>wt", "<c-w>T")
nmap("<leader>w+", "<c-w>+")
nmap("<leader>w-", "<c-w>-")

--Quicklists
nmap("<leader>co", ":copen <CR>")
nmap("<leader>cn", ":cn <CR>")
nmap("<leader>cp", ":cp <CR>")
nmap("<leader>cc", ":cclose <CR>")

-- keep search matches in the middle of the window
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

-- Search and replace
nmap("-", "/<C-n>") -- swedish keyboard
nmap("_", "?<C-n>") -- swedish keyboard
nmap("<leader>rs", ":%s/")

-- Jump prev file
nmap("<C-p>", "<c-^><cr>")

--Plugins
nmap("<leader>pi", ":PackerInstall <CR>")
nmap("<leader>pu", ":PackerSync <CR>")
nmap("<leader>ps", ":PackerStatus <CR>")
--LSP
nmap("<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
nmap("<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
nmap("<leader>K", "<cmd>lua vim.lsp.buf.hover()<CR>")
nmap("<leader>da", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
nmap("<leader>dr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
nmap("<leader>dl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")

nmap("<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
nmap("<leader>s", "<cmd>lua vim.diagnostic.open_float()<CR>")
nmap("<leader>dN", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
nmap("<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>")
nmap("<leader>ds", "<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients(),true)<CR>")
nmap("<leader>cr", "<cmd>lua vim.lsp.buf.formatting()<CR>")

--Telescope
nmap("<leader>gd", ":Telescope lsp_definitions <CR>")
nmap("<leader>gr", ":Telescope lsp_references theme=dropdown<CR>")
nmap("<leader>ca", ":Telescope lsp_code_actions theme=cursor<CR>")

nmap("<leader>fd", ":Telescope diagnostics<CR>")
nmap("<leader>fR", ":Telescope find_files hidden=true cwd=~<CR>")
nmap("<leader>fF", ":Telescope find_files hidden=true <CR>")
nmap("<leader>fr", ":Telescope find_files cwd=~<CR>")
nmap("<leader>ff", ":Telescope find_files <CR>")
nmap(
	"<leader>fc",
	":Telescope find_files prompt_title=~/.config/nvim cwd=~/.config/nvim theme=dropdown previewer=false<CR>"
)

-- NOTE: hardcoded for ~/.dotfiles
nmap(
	"<leader>fC",
	":Telescope git_files hidden=true prompt_title=~/.dotfiles cwd=~/.dotfiles theme=dropdown previewer=false<CR>"
)

nmap("<leader>fo", ":Telescope oldfiles theme=dropdown previewer=false<CR>")
nmap("<leader>fp", ":Telescope git_files <CR>")
nmap("<leader>fg", ":Telescope live_grep <CR>")
nmap("<leader>fb", ":Telescope buffers theme=dropdown previewer=false<CR>")
nmap("<leader>fM", ":Telescope man_pages <CR>")
nmap("<leader>fH", ":Telescope help_tags <CR>")
nmap("<leader>f:", ":Telescope command_history <CR>")
nmap("<leader>fl", ":Telescope current_buffer_fuzzy_find <CR>")
nmap("<leader>fm", ":Telescope keymaps <CR>")

--tree
nmap("<leader>tt", ":NvimTreeToggle <CR>")
nmap("<leader>tf", ":NvimTreeFindFile <CR>")
nmap("<leader>tr", ":NvimTreeRefresh <CR>")

--Git
nmap("<leader>gh", ":Telescope git_commits <CR>")
nmap("<leader>gs", ":G <CR> :resize 15 <CR>")
nmap("<leader>gb", ":Telescope git_branches theme=dropdown<CR>")
nmap("<leader>gl", ":G blame <CR>")
nmap("<leader>gc", ":G commit <CR>")
nmap("<leader>gv", ":Gvdiffsplit <CR>")
-- Hunks
nmap("<leader>gn", ":Gitsigns next_hunk<CR>")
nmap("<leader>gN", ":Gitsigns prev_hunk<CR>")
nmap("<leader>gp", ":Gitsigns preview_hunk<CR>")
nmap("<leader>hs", ":Gitsigns stage_hunk<CR>")
nmap("<leader>hS", ":Gitsigns stage_buffer<CR>")
nmap("<leader>hr", ":Gitsigns reset_hunk<CR>")
nmap("<leader>hr", ":Gitsigns reset_buffer<CR>")
nmap("<leader>hd", ":Gitsigns toggle_deleted<CR>")

-- Text object
omap("ih",":<C-U>Gitsigns select_hunk<CR>")
xmap("ih",":<C-U>Gitsigns select_hunk<CR>")

--Terminal
tmap("<esc>", [[<C-\><C-n>]])
nmap("<leader>;", ":sp<CR>:term<CR>:resize 15<CR>:set nonu<CR>:set norelativenumber<CR>i")

-- Juptext
nmap("<leader>pqt", ':call jobstart("jupyter qtconsole --JupyterWidget.include_other_output=True --style native")<CR>')
nmap("<leader>pqk", ":IPython --existing --no-window <CR>")
nmap("<leader>pk", ":IPython<CR><C-w>H")
nmap("<leader>pc", ":call IPyRunCell()<CR>")
vim.cmd("nmap <leader>pa <Plug>(IPy-RunAll)")
vim.cmd("nmap <leader>pt <Plug>(IPy-Terminate)")
