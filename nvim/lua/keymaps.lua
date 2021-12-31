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

vim.g.mapleader = " ";
--Cycle tabs with tab
nmap('<tab>',':tabnext <CR>')
nmap('<S-tab>',':tabprev <CR>')

nmap('<leader><tab>n',':tabnew <CR>')
nmap('<leader><tab>c',':tabclose <CR>')
nmap('<leader><tab>o',':tabo <CR>')
nmap('<leader><tab>r',"<cmd>lua require('tabline.actions').set_tabname()<CR>")

--Buffer movement
nmap('<leader>l', '<c-w>l')
nmap('<leader>h', '<c-w>h')
nmap('<leader>k', '<c-w>k')
nmap('<leader>j', '<c-w>j')
nmap('<leader>wq', '<c-w>q')
nmap('<leader>wv', '<c-w>v')
nmap('<leader>ws', '<c-w>s')
nmap('<leader>wx', '<c-w>x')
nmap('<leader>we', '<c-w>=')
nmap('<leader>wt', '<c-w>T')
nmap('<leader>w+', '<c-w>+')
nmap('<leader>w-', '<c-w>-')

--Quicklists
nmap('<leader>co', ':copen <CR>')
nmap('<leader>cn', ':cn <CR>')
nmap('<leader>cp', ':cp <CR>')
nmap('<leader>cc', ':cclose <CR>')

-- keep search matches in the middle of the window
nmap('n', 'nzzzv')
nmap('N', 'Nzzzv')

--Plugins
nmap('<leader>pi',':PackerInstall <CR>')
nmap('<leader>pu',':PackerSync <CR>')
nmap('<leader>ps',':PackerStatus <CR>')
--LSP
nmap('<leader>gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
nmap('<leader>K','<cmd>lua vim.lsp.buf.hover()<CR>')
nmap('<leader>gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
nmap('<leader>da','<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
nmap('<leader>dr','<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
nmap('<leader>dl','<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

nmap( '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
nmap( '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' )
nmap( '<leader>s', '<cmd>lua vim.diagnostic.open_float()<CR>')
nmap( '<leader>dN', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
nmap( '<leader>dn', '<cmd>lua vim.diagnostic.goto_next()<CR>')
nmap( '<leader>cr', '<cmd>lua vim.lsp.buf.formatting()<CR>')

--Telescope
nmap('<leader>gd',':Telescope lsp_definitions <CR>')
nmap( '<leader>gr', ':Telescope lsp_references theme=dropdown<CR>')
nmap( '<leader>ca', ':Telescope lsp_code_actions theme=cursor<CR>')

nmap('<leader>fd',":Telescope diagnostics<CR>")
nmap('<leader>fR',':Telescope find_files hidden=true cwd=~<CR>')
nmap('<leader>fF',':Telescope find_files hidden=true <CR>')
nmap('<leader>fr',':Telescope find_files cwd=~<CR>')
nmap('<leader>ff',":Telescope find_files <CR>")
nmap('<leader>fc', ":Telescope find_files prompt_title=~/.config/nvim cwd=~/.config/nvim theme=dropdown previewer=false<CR>")
nmap('<leader>fo',":Telescope oldfiles theme=dropdown previewer=false<CR>")
nmap('<leader>fp',":Telescope git_files <CR>")
nmap('<leader>fP',":Telescope projects theme=dropdown<CR>")
nmap('<leader>fg',":Telescope live_grep <CR>")
nmap('<leader>fb',":Telescope buffers theme=dropdown <CR>")
nmap('<leader>fM',":Telescope man_pages <CR>")
nmap('<leader>fH',":Telescope help_tags <CR>")
nmap('<leader>f:',":Telescope command_history <CR>")
nmap('<leader>fl',":Telescope current_buffer_fuzzy_find <CR>")
nmap('<leader>fm',":Telescope keymaps <CR>")

--tree
nmap('<leader>tt', ':NvimTreeToggle <CR>')
nmap('<leader>tf', ':NvimTreeFindFile <CR>')
nmap('<leader>tr', ':NvimTreeRefresh <CR>')

--Git
nmap('<leader>gh', ':Telescope git_commits <CR>')
nmap('<leader>gs', ':G <CR> :resize 15 <CR>' )
nmap('<leader>gl', ':Telescope git_branches theme=dropdown<CR>' )
nmap('<leader>gp', ':Telescope git_status <CR>' )
nmap('<leader>gb', ':G blame <CR>' )
nmap('<leader>gc', ':G commit <CR>' )
nmap('<leader>gv', ':Gvdiffsplit <CR>' )

--Terminal
tmap('<esc>', [[<C-\><C-n>]])
nmap('<leader>;', ':sp<CR>:term<CR>:resize 15<CR>:set nonu<CR>:set norelativenumber<CR>i')
