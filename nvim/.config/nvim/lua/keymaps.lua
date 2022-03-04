vim.g.mapleader = " "

local utils = require("utils.map")

--Tab navigation
utils.nmap("<leader>1", "1gt")
utils.nmap("<leader>2", "2gt")
utils.nmap("<leader>3", "3gt")
utils.nmap("<leader>4", "4gt")
utils.nmap("<leader>5", "5gt")
utils.nmap("<leader>6", "6gt")
utils.nmap("<leader>7", "7gt")
utils.nmap("<leader>8", "8gt")

utils.nmap("<leader><tab>n", ":tabnew <CR>")
utils.nmap("<leader><tab>c", ":tabclose <CR>")
utils.nmap("<leader><tab>o", ":tabo <CR>")

--Buffer movement
utils.nmap("<leader>l", "<c-w>l")
utils.nmap("<leader>h", "<c-w>h")
utils.nmap("<leader>k", "<c-w>k")
utils.nmap("<leader>j", "<c-w>j")
utils.nmap("<leader>wq", "<c-w>q")
utils.nmap("<leader>wo", "<c-w><c-o>")
utils.nmap("<leader>wv", "<c-w>v")
utils.nmap("<leader>ws", "<c-w>s")
utils.nmap("<leader>wx", "<c-w>x")
utils.nmap("<leader>we", "<c-w>=")
utils.nmap("<leader>wt", "<c-w>T")
utils.nmap("<leader>w+", "<c-w>+")
utils.nmap("<leader>w-", "<c-w>-")
utils.nmap("<leader>w<", "<c-w<")
utils.nmap("<leader>w>", "<c-w>")
utils.nmap("<leader>wL", "<c-w>L")
utils.nmap("<leader>wH", "<c-w>H")
utils.nmap("<leader>wK", "<c-w>K")
utils.nmap("<leader>wJ", "<c-w>J")

--Quicklists
utils.nmap("<leader>co", ":copen <CR>")
utils.nmap("<leader>cn", ":cn <CR>")
utils.nmap("<leader>cp", ":cp <CR>")
utils.nmap("<leader>cc", ":cclose <CR>")

-- keep search matches in the middle of the window
utils.nmap("n", "nzzzv")
utils.nmap("N", "Nzzzv")

-- Search and replace
utils.nmap("-", "/<C-n>") -- swedish keyboard
utils.nmap("_", "?<C-n>") -- swedish keyboard
utils.nmap("<leader>rs", ":%s/<C-n>")

-- Jump prev file
utils.nmap("<C-p>", "<c-^><cr>")

--Plugins
utils.nmap("<leader>pi", ":PackerInstall <CR>")
utils.nmap("<leader>ps", ":PackerSync <CR>")
utils.nmap("<leader>pc", ":PackerCompile <CR>")
utils.nmap("<leader>pl", ":PackerStatus <CR>")

--LSP
utils.nmap("<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
utils.nmap("<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
utils.nmap("<leader>K", "<cmd>lua vim.lsp.buf.hover()<CR>")
utils.nmap("<leader>da", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
utils.nmap("<leader>dr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
utils.nmap("<leader>dl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")

utils.nmap("<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
utils.nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
utils.nmap("<leader>s", "<cmd>lua vim.diagnostic.open_float()<CR>")
utils.nmap("<leader>dN", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
utils.nmap("<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>")
utils.nmap("<leader>ds", "<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients(),true)<CR>")
utils.nmap("<leader>cr", "<cmd>lua vim.lsp.buf.formatting()<CR>")

--Telescope
utils.nmap("<leader>gd", ":Telescope lsp_definitions <CR>")
utils.nmap("<leader>gr", ":Telescope lsp_references<CR>")
utils.nmap("<leader>ca", ":Telescope lsp_code_actions theme=cursor<CR>")

utils.nmap("<leader>fd", ":Telescope diagnostics<CR>")
utils.nmap("<leader>fF", ":FZF ~<CR>")
utils.nmap("<leader>ff", ":FZF<CR>")
utils.nmap("<leader>fc", ":FZF ~/.config/nvim <CR>")

-- NOTE: hardcoded for ~/.dotfiles
utils.nmap("<leader>fC", ":FZF ~/.dotfiles <CR>")

utils.nmap("<leader>fo", ":History <CR>")
utils.nmap("<leader>fp", ":GFiles <CR>")
utils.nmap("<leader>fg", ":Telescope live_grep <CR>")
utils.nmap("<leader>fb", ":Buffers <CR>")
utils.nmap("<leader>fM", ":Telescope man_pages <CR>")
utils.nmap("<leader>fH", ":Helptags <CR>")
utils.nmap("<leader>f:", ":Commands <CR>")
utils.nmap("<leader>fl", ":Telescope current_buffer_fuzzy_find <CR>")
utils.nmap("<leader>fm", ":Maps <CR>")

--tree
utils.nmap("<leader>tt", ":NvimTreeToggle <CR>")
utils.nmap("<leader>tf", ":NvimTreeFindFile <CR>")
utils.nmap("<leader>tr", ":NvimTreeRefresh <CR>")

--Git
utils.nmap("<leader>gc", ":Commits <CR>")
utils.nmap("<leader>gs", ":G <CR> :resize 15 <CR>")
utils.nmap("<leader>gb", ":Telescope git_branches<CR>")
utils.nmap("<leader>gl", ":G blame <CR>")
utils.nmap("<leader>gv", ":Gvdiffsplit <CR>")
utils.nmap("<leader>gn", ":Gitsigns next_hunk<CR>")
utils.nmap("<leader>gN", ":Gitsigns prev_hunk<CR>")
utils.nmap("<leader>gp", ":Gitsigns preview_hunk<CR>")
utils.nmap("<leader>ghs", ":Gitsigns stage_hunk<CR>")
utils.nmap("<leader>ghS", ":Gitsigns stage_buffer<CR>")
utils.nmap("<leader>ghr", ":Gitsigns reset_hunk<CR>")
utils.nmap("<leader>ghR", ":Gitsigns reset_buffer<CR>")
utils.nmap("<leader>gtd", ":Gitsigns toggle_deleted<CR>")

-- Text object
utils.omap("ih", ":<C-U>Gitsigns select_hunk<CR>")
utils.xmap("ih", ":<C-U>Gitsigns select_hunk<CR>")

--Terminal
utils.tmap("<C-e>", [[<C-\><C-n>]])
utils.nmap("<leader>;", ":sp<CR>:term<CR>:resize 15<CR>:set nonu<CR>:set norelativenumber<CR>i")

-- Juptext
utils.nmap(
	"<leader>pqt",
	':call jobstart("jupyter qtconsole --JupyterWidget.include_other_output=True --style native")<CR>'
)
utils.nmap("<leader>pqk", ":IPython --existing --no-window <CR>")
utils.nmap("<leader>pk", ":IPython<CR><C-w>H")
utils.nmap("<leader>pc", ":call IPyRunCell()<CR>")
vim.cmd("nmap <leader>pa <Plug>(IPy-RunAll)")
vim.cmd("nmap <leader>pt <Plug>(IPy-Terminate)")
