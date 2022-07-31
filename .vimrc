"General
filetype plugin indent on
set nocompatible
set autoread
set mouse=a
set ttyfast

set wildmenu
set wildoptions="fuzzy,tagfile"
set path=src/,test/,config/
set path+=~/.dotfiles

set shiftwidth=4
set tabstop=4
set expandtab
set autoindent
set cindent
set nowrap

set splitbelow
set splitright

set scrolloff=8
set signcolumn=number
set nu

set incsearch
set nohlsearch

set hidden
set history=100
set noswapfile
set nobackup writebackup

"Create Undo directory
if !isdirectory("/var/tmp/vim/undo")
    call mkdir("/var/tmp/vim/undo", "p", 0700)
endif
set undodir=/var/tmp/vim/undo
set undofile

"Cosmetic
set ruf=
set ruf +=%45(%=%#LineNr#%.50F\%m%r\ [%{strlen(&ft)?&ft:'none'}]\ %l:%c\ %P%)

set laststatus=0
set statusline=
set statusline +=\ %4F
set statusline +=\%m\%r
set statusline +=\ [%{strlen(&ft)?&ft:'none'}]
set statusline +=\ %=%l:%c
set statusline +=\ %-4P

set fillchars=vert:\│,stl:\―,stlnc:\―,eob:\ ,
set background=dark
syntax enable

"Keymaps
map <Space> <Leader>

nnoremap <C-p> <C-^>
nnoremap <Leader>rs :%s/
nnoremap <Leader>rr <cmd>w \| source % <CR>

nnoremap <Leader>co <cmd>copen<CR>
nnoremap <Leader>cc <cmd>cclose<CR>
nnoremap <Leader>cn <cmd>cnext<CR>
nnoremap <Leader>cf <cmd>cfirst<CR>
nnoremap <Leader>cl <cmd>clast<CR>
nnoremap <Leader>cp <cmd>cprev<CR>
nnoremap <Leader>cN <cmd>cnf<CR>
nnoremap <Leader>cP <cmd>cpf<CR>

nnoremap <Leader>lo <cmd>lopen<CR>
nnoremap <Leader>lc <cmd>lclose<CR>
nnoremap <Leader>ln <cmd>lnext<CR>
nnoremap <Leader>lp <cmd>lprev<CR>
nnoremap <Leader>lf <cmd>lfirst<CR>
nnoremap <Leader>ll <cmd>llast<CR>

nnoremap <Leader>tt :tag 
nnoremap <Leader>t/ :tag /
nnoremap <Leader>tP :ptag 
nnoremap <Leader>ts <cmd>tags<CR>
nnoremap <Leader>tn <cmd>tnext<CR>
nnoremap <Leader>tf <cmd>tfirst<CR>
nnoremap <Leader>tp <cmd>tprevious<CR>
nnoremap <Leader>tl <cmd>tlast<CR>

nnoremap gA :args 
nnoremap <silent> gr :vimgrep /\<<C-R><C-W>\>/gj `git ls-files` \|\| copen<CR>
nnoremap gR :vimgrep /\<<C-R><C-W>\>/g

nnoremap <Leader>ff :find **/
nnoremap <Leader>fF :edit **/

"Abbreviations
cabbr gls `git ls-files`

"Functions
function! FilterRestorePos(cmd)
	let save_pos = getpos(".")
	silent execute a:cmd
	call setpos(".", save_pos)
endfunction

"Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

if filereadable(expand("~/.vim/autoload/plug.vim"))
    call plug#begin('~/.vim/vim-plug')
    Plug 'junegunn/vim-plug'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'jiangmiao/auto-pairs'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'tomasiser/vim-code-dark', { 'do': ':colorscheme codedark' }
    Plug 'dense-analysis/ale', { 'on' : ['ALEToggle'] }
    Plug 'lervag/vimtex', { 'for': 'tex' }
    Plug 'mattn/emmet-vim', { 'for' : ['javascript','html','javascriptreact'] }
    Plug 'maxmellon/vim-jsx-pretty', { 'for' : ['javascript', 'javascriptreact'] }
    call plug#end()

    "ALE
    nnoremap <Leader>ca <Cmd>ALECodeAction<CR>
    nnoremap <Leader>cr <Cmd>ALEFix<CR>
    nnoremap <Leader>rn <Cmd>ALERename<CR>
    nnoremap <Leader>K <Cmd>ALEHover<CR>
    nnoremap <Leader>gd <Cmd>ALEGoToDefinition<CR>
    nnoremap <Leader>gt <Cmd>ALEGoToTypeDefinition<CR>
    nnoremap <Leader>gi <Cmd>ALEGoToImplementation<CR>
    nnoremap <Leader>gr <Cmd>ALEFindReferences -quickfix<CR><CMD>copen<CR>
    nnoremap <Leader>di <Cmd>ALEDetail<CR>
    nnoremap <Leader>ds <Cmd>ALEToggle<CR><Cmd>echo g:ale_enabled<CR>
    nnoremap <Leader>dq <Cmd>ALEPopulateQuickfix<CR>
    let g:ale_enabled = 0
    let g:ale_hover_cursor = 0
    let g:ale_set_highlights = 0

    "Autopairs
    let g:AutoPairsCenterLine = 0

    "Fugitive
    augroup ft_fugitve
        autocmd Filetype fugitive setlocal scl=yes
        autocmd Filetype fugitive setlocal nonu
    augroup END

    nnoremap <silent> <Leader>gs :vert Git \|vertical resize 80 <CR>
    nnoremap <Leader>gb :G blame <CR>
    nnoremap <Leader>gv :Gvdiffsplit <CR>

    "Vim-plug
    nnoremap <Leader>pi :PlugInstall<CR>
    nnoremap <Leader>pu :PlugUpdate<CR>
    nnoremap <Leader>pl :PlugStatus<CR>
    nnoremap <Leader>pc :PlugClean<CR>
    nnoremap <Leader>pd :PlugDiff<CR>

endif

"Set colorsheme if installed
silent! colorscheme codedark

"Highlights
hi Normal ctermbg=NONE guibg=NONE
hi EndOfBuffer ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
hi LineNr ctermbg=NONE guibg=NONE
hi VertSplit ctermbg=NONE 
hi! link ModeMsg Normal
hi! link StatusLineNC VertSplit
hi! link StatusLine LineNr
hi! link qfLineNr Title
