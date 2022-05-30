"General
filetype plugin indent on
set nocompatible
set nofixendofline
set autoread
set mouse=a
set ttyfast

set wildmenu
set wildoptions="pum,tagfile"

set shiftwidth=4
set tabstop=4
set expandtab
set smarttab
set autoindent
set smartindent
set textwidth=72
set nowrap

set hidden
set history=100
set noswapfile
set undofile 
set backup

set splitbelow
set splitright
set scrolloff=8
set nu

set incsearch
set ignorecase
set smartcase
set nohlsearch

"Cosmetic
set ruf=
set ruf +=%35(%=%#LineNr#%.50F\%m\ [%{strlen(&ft)?&ft:'none'}]\ %l:%c\ %P%)

set laststatus=1
set statusline=
set statusline +=\ %4F
set statusline +=\%m
set statusline +=\ [%{strlen(&ft)?&ft:'none'}]
set statusline +=\ %=%l:%c
set statusline +=\ %-4P

set background=dark
syntax enable

"Keymaps
map <Space> <Leader>

nnoremap <C-p> <C-^>
nnoremap <Leader>rs :%s/
nnoremap <Leader>rr <cmd>source % <CR><cmd><CR>

nnoremap <Leader>co <cmd>copen<CR><cmd><CR>
nnoremap <Leader>cc <cmd>cclose<CR><cmd><CR>
nnoremap <Leader>cn <cmd>cnext<CR><cmd><CR>
nnoremap <Leader>cp <cmd>cprev<CR><cmd><CR>


"Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

if filereadable(expand("~/.vim/autoload/plug.vim"))
    call plug#begin('~/.vim/vim-plug')
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
    Plug 'tpope/vim-fugitive'
    Plug 'tomasiser/vim-code-dark'
    Plug 'lervag/vimtex', { 'for': 'latex'}
    call plug#end()

    "FZF
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

    noremap <Leader>fc :Files ~/.dotfiles<CR>

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

    "Fugitive
    nnoremap <Leader>gs :vert Git \|vertical resize 80 <CR>
    nnoremap <Leader>gb :G blame <CR>
    nnoremap <Leader>gv :Gvdiffsplit <CR>

    "Vim-plug
    nnoremap <Leader>pi :PlugInstall<CR>
    nnoremap <Leader>pu :PlugUpdate<CR>

    "Set colorsheme if installed
    colorscheme codedark
endif

"Highlights
hi Normal ctermbg=NONE guibg=NONE
hi EndOfBuffer ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
hi LineNr ctermbg=NONE guibg=NONE
hi! link ModeMsg Normal
