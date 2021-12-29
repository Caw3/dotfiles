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

--Cycle tabs with tab
nmap('<tab>',':tabnext <CR>')
nmap('<S-tab>',':tabprev <CR>')

--Buffer movement
nmap('<Leader>l', '<c-w>l')
nmap('<Leader>h', '<c-w>h')
nmap('<Leader>k', '<c-w>k')
nmap('<Leader>j', '<c-w>j')
nmap('<Leader>wq', '<c-w>q')
nmap('<Leader>wv', '<c-w>v')
nmap('<Leader>wx', '<c-w>x')
nmap('<Leader>we', '<c-w>=')
nmap('<Leader>wt', '<c-w>T')

--Quicklists
nmap('<Leader>co', ':copen <CR>')
nmap('<Leader>cn', ':cnext <CR>')
nmap('<Leader>cp', ':cprev <CR>')
nmap('<Leader>cc', ':cclose <CR>')

-- keep search matches in the middle of the window
nmap('n', 'nzzzv')
nmap('N', 'Nzzzv')

--Plugins
--LSP
nmap('<Leader>gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
nmap('<Leader>K','<cmd>lua vim.lsp.buf.hover()<CR>')
nmap('<Leader>gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
nmap('<Leader>da','<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
nmap('<Leader>dr','<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
nmap('<Leader>dl','<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

nmap( '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
nmap( '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' )
nmap( '<Leader>s', '<cmd>lua vim.diagnostic.open_float()<CR>')
nmap( '<Leader>dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
nmap( '<Leader>dn', '<cmd>lua vim.diagnostic.goto_next()<CR>')
-- nmap( '<Leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
nmap( '<Leader>cr', '<cmd>lua vim.lsp.buf.formatting()<CR>')

--Telescope
nmap('<Leader>gd',':Telescope lsp_definitions <CR>')
nmap( '<Leader>ca', ':Telescope lsp_code_actions theme=cursor<CR>')
nmap( '<Leader>gr', ':Telescope lsp_references <CR>')
nmap('<Leader>fd',":Telescope diagnostics<CR>")
nmap('<Leader>fR',":Telescope find_files hidden=true cwd=~<CR>")
nmap('<Leader>fr',":Telescope find_files cwd=~<CR>")
nmap('<Leader>ff',":Telescope find_files hidden=true <CR>")
nmap('<Leader>fp',":Telescope git_files <CR>")
nmap('<Leader>fP',":Telescope projects theme=dropdown<CR>")
nmap('<Leader>fg',":Telescope live_grep <CR>")
nmap('<Leader>fb',":Telescope file_browser <CR>")
nmap('<Leader>fh',":Telescope man_pages <CR>")
nmap('<Leader>f:',":Telescope command_history <CR>")
nmap('<Leader>fl',":Telescope current_buffer_fuzzy_find <CR>")
nmap('<Leader>fm',":Telescope keymaps <CR>")

--tree
nmap('<Leader>tt', ':NvimTreeToggle <CR>')
nmap('<Leader>tf', ':NvimTreeFindFile <CR>')
nmap('<Leader>tr', ':NvimTreeRefresh <CR>')

--Git
nmap('<Leader>gh', ':Telescope git_commits <CR>')
nmap('<Leader>gs', ':Telescope git_status <CR>' )
nmap('<Leader>gl', ':Telescope git_branches theme=dropdown<CR>' )
nmap('<Leader>gb', ':G blame <CR>' )
nmap('<Leader>gc', ':G commit <CR>' )
nmap('<Leader>gv', ':Gvdiffsplit <CR>' )
