"General
filetype plugin indent on
set nocompatible
set nofixendofline
set autoread
set mouse=a
set ttimeoutlen=0
set ttyfast

set wildmenu
set wildoptions="fuzzy,pum,tagfile"

set shiftwidth=4
set tabstop=4
set expandtab
set autoindent
set smartindent
set cindent

set textwidth=72
set nowrap

set hidden
set history=100
set nobk nowb noswf noudf 

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
set ruf +=%45(%=%#LineNr#%.50F\%m\ [%{strlen(&ft)?&ft:'none'}]\ %l:%c\ %P%)

set laststatus=1
set statusline=
set statusline +=\ %4F
set statusline +=\%m
set statusline +=\ [%{strlen(&ft)?&ft:'none'}]
set statusline +=\ %=%l:%c
set statusline +=\ %-4P

set fillchars=vert:\│
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
    silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs
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
    Plug 'tpope/vim-endwise', { 'for' : ['lua','ruby','bash','haskell'] }
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-fugitive'
    Plug 'tomasiser/vim-code-dark', { 'do': ':colorscheme codedark' }
    Plug 'lervag/vimtex', { 'for': 'latex' }
    Plug 'dense-analysis/ale', { 'on' : ['ALEToggle'] }
    Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
    call plug#end()

    "ALE
    function! ToggleAle()
        execute 'ALEToggle'
        if g:ale_enabled
            set scl=yes
        else
            set scl=no
        endif
    endfunction

    nnoremap <Leader>ca <Cmd>ALECodeAction<CR>
    nnoremap <Leader>cr <Cmd>ALEFix<CR>
    nnoremap <Leader>rn <Cmd>ALERename<CR>
    nnoremap <Leader>K <Cmd>ALEHover<CR>
    nnoremap <Leader>gd <Cmd>ALEGoToDefinition<CR>
    nnoremap <Leader>gr <Cmd>ALEFindReferences<CR>
    nnoremap <Leader>di <Cmd>ALEDetail<CR>
    nnoremap <Leader>ds <Cmd>call ToggleAle()<CR>
    nnoremap <silent> <Leader>dp <Plug>(ale_previous_wrap)
    nnoremap <silent> <Leader>dn <Plug>(ale_next_wrap)
    let g:ale_enabled = 0
    let g:ale_hover_cursor = 0
    let g:ale_set_highlights = 0
    let g:ale_sign_column_always = 1
    let g:ale_set_loclist = 0
    let g:ale_set_quickfix = 1

    "Autopairs
    let g:AutoPairsCenterLine = 0

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

    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
      copen
      cc
    endfunction

    let g:fzf_buffers_jump = 0
    let g:fzf_layout = {
        \ 'window': {
            \ 'width': 1.0,
            \ 'height': 0.4,
            \ 'yoffset': 1.0,
            \ 'border': 'top' } }
    let g:fzf_action = {
        \ 'ctrl-q': function('s:build_quickfix_list'),
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit' }

    "Fugitive
    nnoremap <silent> <Leader>gs :vert Git \|vertical resize 80 <CR>
    nnoremap <Leader>gb :G blame <CR>
    nnoremap <Leader>gv :Gvdiffsplit <CR>

    "Vim-plug
    nnoremap <Leader>pi :PlugInstall<CR>
    nnoremap <Leader>pu :PlugUpdate<CR>
    nnoremap <Leader>pl :PlugStatus<CR>
    nnoremap <Leader>pc :PlugClean<CR>

endif

"Set colorsheme if installed
silent! colorscheme codedark

"Highlights
hi Normal ctermbg=NONE guibg=NONE
hi EndOfBuffer ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
hi LineNr ctermbg=NONE guibg=NONE
hi! link ModeMsg Normal
