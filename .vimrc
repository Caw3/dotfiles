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
set smartindent
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

inoremap {<cr> {<cr>}<c-o><s-o>

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

nnoremap <silent> <Leader>* :Grep <C-R><C-W><CR>
nnoremap <Leader>/ :Grep 

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

set grepprg=rg\ --vimgrep
function! Grep(...)
	return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup quickfix
	autocmd!
	autocmd QuickFixCmdPost cgetexpr cwindow
	autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

packadd cfilter

"Plugins
if empty(glob('~/.vim/autoload/plug.vim')) && v:version >= 810
    silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

if filereadable(expand("~/.vim/autoload/plug.vim"))
    call plug#begin('~/.vim/vim-plug')
	Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-fugitive'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'arcticicestudio/nord-vim'
    Plug 'maxmellon/vim-jsx-pretty', { 'for' : ['javascript', 'javascriptreact'] }
    Plug 'lervag/vimtex', { 'for': 'tex' }
	Plug 'neovimhaskell/haskell-vim', { 'for' : 'haskell' }
    Plug 'dense-analysis/ale', { 'on' : ['ALEToggle'] }
	Plug 'github/copilot.vim', { 'on' : ['Copilot'] }
    call plug#end()

	"Copilot
	nnoremap <Leader>aie <Cmd>Copilot enable<CR><Cmd>Copilot status<CR>
	nnoremap <Leader>aid <Cmd>Copilot disable<CR><Cmd>Copilot status<CR>
	nnoremap <Leader>aip <Cmd>vert Copilot panel<CR>


	"Termdebug
	packadd termdebug
	let g:termdebug_wide=1
	nnoremap <Leader>db <Cmd>Termdebug<CR>
	tnoremap <C-j> <Cmd>TmuxNavigateDown<CR>
	tnoremap <C-k> <Cmd>TmuxNavigateUp<CR>
	tnoremap <C-h> <Cmd>TmuxNavigateLeft<CR>
	tnoremap <C-l> <Cmd>TmuxNavigateRight<CR>

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
	vnoremap <leader>gl <ESC>:execute 'vert G log -L' . line("'<") . ',' . line("'>") . ':' . expand('%') <CR>
    nnoremap <Leader>gqc <Cmd> silent G difftool \| copen<CR>
    nnoremap <Leader>gqm <Cmd> silent G mergetool \| copen<CR>
    nnoremap <Leader>gv :Gvdiffsplit <CR>

	"FZF
	function! s:build_quickfix_list(lines)
		call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
		copen
		cc
	endfunction
	let g:fzf_action = { 'ctrl-q': function('s:build_quickfix_list') }
	let g:fzf_buffers_jump = 1
	let g:fzf_layout = { 'tmux': '-p'}
	nnoremap <Leader>fg <Cmd>GFiles<Cr>
	nnoremap <Leader>ff <Cmd>Files<Cr>
	nnoremap <Leader>fs <Cmd>Rg<Cr>


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
