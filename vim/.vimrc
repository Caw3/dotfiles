let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/vim-plug')

Plug 'junegunn/vim-plug'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'raimondi/delimitmate'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tomasiser/vim-code-dark'
Plug 'lervag/vimtex', { 'for': 'latex'}

call plug#end()

"General
set shiftwidth=4
set tabstop=4
filetype plugin indent on
set hidden
set nocompatible
set noswapfile
set smartindent
set autoindent
set undofile 
set backup
set nowrap
set splitbelow
set splitright
set scrolloff=8
set incsearch
set ignorecase
set smartcase
set nohlsearch
set scl=yes
set nu

"Cosmetic
set ruf=
set ruf +=%35(%=%#LineNr#%.50F\%m\ [%{strlen(&ft)?&ft:'none'}]\ %l:%c\ %P%)

set laststatus=1
set statusline=
set statusline +=\ %F
set statusline +=\%m
set statusline +=\ [%{strlen(&ft)?&ft:'none'}]

set statusline +=\ %=%l:%c
set statusline +=\ %P

set termguicolors
set term=xterm-256color
set background=dark
colorscheme codedark
highlight clear SignColumn
hi EndOfBuffer guifg=#1E1E1E
hi DiffAdd guibg=#1e1e1e guifg=#608B4E
hi DiffDelete guibg=#1e1e1e guifg=#F44747
hi DiffChange guibg=#1e1e1e guifg=#C586C0
" hi TabLineFill guibg=#1e1e1e
hi StatusLine guibg=#252526
hi! link GitSignsAdd DiffAdd
hi! link GitSignsChange DiffChange
hi! link GitSignsDelete DiffDelete
hi! link ModeMsg Normal

map <Space> <Leader>
map <C-p> <C-^>
"FZF keybind
nnoremap <Leader>fR :Files ~<CR>
nnoremap <Leader>ff :Files <CR>
nnoremap <Leader>fp :GitFiles <CR>
nnoremap <Leader>fg :Rg .<CR>
nnoremap <Leader>fH :Help <CR>
nnoremap <Leader>fb :Buffers <CR>
nnoremap <Leader>fo :History <CR>
nnoremap <Leader>f: :History: <CR>
nnoremap <Leader>fl :BLines <CR>
nnoremap <Leader>gc :Commits <CR>
nnoremap <Leader>fm :Maps <CR>

let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 0.4, 'yoffset': 1.0, 'border': 'top' } }

let g:fzf_buffers_jump = 1

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }


"Git
nnoremap <Leader>gs :vert Git <CR> vertical resize 80 <CR> 
nnoremap <Leader>gb :G blame <CR>
nnoremap <Leader>gv :Gvdiffsplit <CR>

"Vim-plug
nnoremap <Leader>pi :PlugInstall<CR>
nnoremap <Leader>pu :PlugUpdate<CR>
