vim.g.mapleader = " "

local utils = require("utils.map")

--Quicklists
utils.nmap("<leader>co", ":copen <CR>")
utils.nmap("<leader>cn", ":cn <CR>")
utils.nmap("<leader>cp", ":cp <CR>")
utils.nmap("<leader>cc", ":cclose <CR>")

-- Search and replace
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

--Git
utils.nmap("<leader>gc", ":Commits <CR>")
utils.nmap("<leader>gs", ":vert Git | vertical resize 80 <CR>")
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

-- Juptext
-- utils.nmap(
-- 	"<leader>pqt",
-- 	':call jobstart("jupyter qtconsole --JupyterWidget.include_other_output=True --style native")<CR>'
-- )
-- utils.nmap("<leader>pqk", ":IPython --existing --no-window <CR>")
-- utils.nmap("<leader>pk", ":IPython<CR><C-w>H")
-- utils.nmap("<leader>pc", ":call IPyRunCell()<CR>")
-- vim.cmd("nmap <leader>pa <Plug>(IPy-RunAll)")
-- vim.cmd("nmap <leader>pt <Plug>(IPy-Terminate)")
