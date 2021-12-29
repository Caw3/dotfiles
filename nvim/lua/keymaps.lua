--Wrapper Functions
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

function vmap(shortcut, command)
  map('v', shortcut, command)
end

function cmap(shortcut, command)
  map('c', shortcut, command)
end

function tmap(shortcut, command)
  map('t', shortcut, command)
end
function xmap(shortcut, command)
  map('x', shortcut, command)
end
--Keybinds
vim.cmd('map <Space> <Leader>')
vim.g.mapleader = " ";
--Cycle tabs with tab
nmap('<tab>',':tabnext <CR>')
nmap('<S-tab>',':tabprev <CR>')

--Buffer movement
nmap('<leader>l', '<c-w>l')
nmap('<leader>h', '<c-w>h')
nmap('<leader>k', '<c-w>k')
nmap('<leader>j', '<c-w>j')
nmap('<leader>wq', '<c-w>q')
nmap('<leader>wv', '<c-w>v')
nmap('<leader>wx', '<c-w>x')
nmap('<leader>we', '<c-w>=')
nmap('<leader>wt', '<c-w>T')

--Quicklists
nmap('<leader>co', ':copen <CR>')
nmap('<leader>cn', ':cnext <CR>')
nmap('<leader>cp', ':cprev <CR>')
nmap('<leader>cc', ':cclose <CR>')

-- keep search matches in the middle of the window
nmap('n', 'nzzzv')
nmap('N', 'Nzzzv')

--Plugins
--LSP
nmap('<leader>gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
nmap('<leader>K','<cmd>lua vim.lsp.buf.hover()<CR>')
nmap('<leader>gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
nmap('<leader>da','<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
nmap('<leader>dr','<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
nmap('<leader>dl','<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

nmap( '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
nmap( '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' )
nmap( '<leader>s', '<cmd>lua vim.diagnostic.open_float()<CR>')
nmap( '<leader>dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
nmap( '<leader>dn', '<cmd>lua vim.diagnostic.goto_next()<CR>')
-- nmap( '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
nmap( '<leader>cr', '<cmd>lua vim.lsp.buf.formatting()<CR>')

--Telescope
nmap('<leader>gd',':Telescope lsp_definitions <CR>')
nmap( '<leader>ca', ':Telescope lsp_code_actions theme=cursor<CR>')
nmap( '<leader>gr', ':Telescope lsp_references <CR>')
nmap('<leader>fd',":Telescope diagnostics<CR>")
nmap('<leader>fR',":Telescope find_files hidden=true cwd=~<CR>")
nmap('<leader>fr',":Telescope find_files cwd=~<CR>")
nmap('<leader>ff',":Telescope find_files hidden=true <CR>")
nmap('<leader>fp',":Telescope git_files <CR>")
nmap('<leader>fP',":Telescope projects theme=dropdown<CR>")
nmap('<leader>fg',":Telescope live_grep <CR>")
nmap('<leader>fb',":Telescope file_browser <CR>")
nmap('<leader>fh',":Telescope man_pages <CR>")
nmap('<leader>f:',":Telescope command_history <CR>")
nmap('<leader>fl',":Telescope current_buffer_fuzzy_find <CR>")
nmap('<leader>fm',":Telescope keymaps <CR>")

--tree
nmap('<leader>tt', ':NvimTreeToggle <CR>')
nmap('<leader>tf', ':NvimTreeFindFile <CR>')
nmap('<leader>tr', ':NvimTreeRefresh <CR>')

--Git
nmap('<leader>gh', ':Telescope git_commits <CR>')
nmap('<leader>gs', ':G <CR>' )
nmap('<leader>gl', ':Telescope git_branches theme=dropdown<CR>' )
nmap('<leader>gb', ':G blame <CR>' )
nmap('<leader>gc', ':G commit <CR>' )
nmap('<leader>gv', ':Gvdiffsplit <CR>' )

--Terminal
tmap('<esc>', [[<C-\><C-n>]])
nmap(';', ':sp <CR> :term <CR> :resize 15 <CR> :set nonu <CR> :set norelativenumber <CR> i')

