filetype plugin indent on
set autoread
set mouse=a
set ttyfast

set wildmenu
set wildoptions="fuzzy,tagfile"
set path=src/,test/,config/
set path+=~/.dotfiles

set shiftwidth=4
set tabstop=4
set smarttab
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
set noswapfile
set nobackup writebackup

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

set fillchars=vert:\│,stl:\―,stlnc:\―
set background=dark
syntax enable

"Keymaps
map <Space> <Leader>

nnoremap <C-p> <C-^>
nnoremap <Leader>rs :%s/
nnoremap <Leader>vr <cmd>w \| source % <CR>

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

nnoremap <Leader>m% <cmd>make! %<CR>
nnoremap <Leader>mm <cmd>make!<CR>

nnoremap <Leader>nn <cmd>set nu!<CR>

nnoremap gA :args 
nnoremap <silent> gr :vimgrep /\<<C-R><C-W>\>/gj `git ls-files` \|\| copen<CR>
nnoremap gR :vimgrep /\<<C-R><C-W>\>/g

nnoremap <Leader>fF :find **/
nnoremap <Leader>ff :edit **/

tnoremap <C-j> <c-w>j
tnoremap <C-k> <c-w>k
tnoremap <C-h> <c-w>h
tnoremap <C-l> <c-w>l

"Abbreviations
cabbr gls `git ls-files`

"Functions
function! ExecAndRestorePos(cmd)
	let save_pos = getpos(".")
	silent execute a:cmd
	call setpos(".", save_pos)
endfunction

"Plugins
if empty(glob('~/.vim/autoload/plug.vim')) && v:version >= 810
    silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

if filereadable(expand("~/.vim/autoload/plug.vim"))
    call plug#begin('~/.vim/vim-plug')
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
	Plug 'romainl/vim-devdocs'
	Plug 'romainl/vim-cool'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'arcticicestudio/nord-vim', { 'do' : 'colorscheme nord' }
    Plug 'dense-analysis/ale', { 'on' : ['ALEToggle'] }
	Plug 'preservim/tagbar'
	Plug 'ludovicchabant/vim-gutentags'
    Plug 'lervag/vimtex', { 'for': 'tex' }
    Plug 'mattn/emmet-vim', { 'for' : ['javascript','html','javascriptreact'] }
    Plug 'maxmellon/vim-jsx-pretty', { 'for' : ['javascript', 'javascriptreact'] }
    call plug#end()

	"Termdebug
	packadd termdebug
	let g:termdebug_wide=1
	nnoremap <Leader>db <Cmd>Termdebug<CR>
	tnoremap <C-j> <Cmd>TmuxNavigateDown<CR>
	tnoremap <C-k> <Cmd>TmuxNavigateUp<CR>
	tnoremap <C-h> <Cmd>TmuxNavigateLeft<CR>
	tnoremap <C-l> <Cmd>TmuxNavigateRight<CR>

	"vim-cool
	set hlsearch
	let g:cool_total_matches = 1

	"Tagbar
	nnoremap <leader>tT :TagbarToggle<CR>

    "ALE
    nnoremap <Leader>ca <Cmd>ALECodeAction<CR>
    nnoremap <Leader>cr <Cmd>ALEFix<CR>
    nnoremap <Leader>rn <Cmd>ALERename<CR>
    nnoremap <Leader>K <Cmd>ALEHover<CR>
    nnoremap <Leader>gd <Cmd>ALEGoToDefinition<CR>
    nnoremap <Leader>gi <Cmd>ALEGoToImplementation<CR>
    nnoremap <Leader>gr <Cmd>ALEFindReferences -quickfix<CR><CMD>copen<CR>
    nnoremap <Leader>di <Cmd>ALEDetail<CR>
    nnoremap <Leader>ds <Cmd>call ExecAndRestorePos("ALEToggle")<CR><Cmd>echo g:ale_enabled<CR>
    nnoremap <Leader>dq <Cmd>ALEPopulateQuickfix<CR>
    nnoremap <Leader>oi <Cmd>ALEOrganizeImports<CR>
    nnoremap <Leader>ss :ALESymbolSearch 

    let g:ale_enabled = 0
    let g:ale_hover_cursor = 0
    let g:ale_set_highlights = 0
    let g:ale_echo_msg_format = '[%severity%][%linter%] %s'

    "Fugitive
    augroup ft_fugitve
        autocmd Filetype fugitive setlocal scl=yes
        autocmd Filetype fugitive setlocal nonu
    augroup END

    nnoremap <silent> <Leader>gs :vert Git \|vertical resize 80 <CR>
    nnoremap <Leader>gb :G blame <CR>
    nnoremap <Leader>gl :Gclog<CR>
    nnoremap <Leader>gqc <Cmd> silent G difftool \| copen<CR>
    nnoremap <Leader>gqm <Cmd> silent G mergetool \| copen<CR>
    nnoremap <Leader>gv :Gvdiffsplit <CR>

endif

"Colors
silent! colorscheme nord
hi VertSplit ctermbg=NONE 
hi! link StatusLineNC VertSplit
hi! link StatusLine LineNr
hi! link StatusLineTermNC VertSplit
hi! link StatusLineTerm LineNr
hi! link debugPC Visual
hi! link debugBreakpoint TODO
hi! link QuickFixLine Visual
hi! link qfError Number 
hi! link qfFilename Conditional
