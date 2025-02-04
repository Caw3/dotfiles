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
set hlsearch
set hidden
set noswapfile
set nobackup writebackup
set nocompatible
set backspace=indent,eol,start
set foldlevelstart=99
set foldmethod=syntax
set foldnestmax=1

if !isdirectory("/var/tmp/vim/undo")
    call mkdir("/var/tmp/vim/undo", "p", 0700)
endif
set undodir=/var/tmp/vim/undo
set undofile

"Keymaps
map <Space> <Leader>
inoremap {<cr> {<cr>}<c-o><s-o>

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

nnoremap <Leader>nn <cmd>set nu!<CR>

nnoremap <silent> <Leader>* :Grep <C-R><C-W><CR>
nnoremap <Leader>/ :Grep 

nnoremap <Leader>fF :find **/*
nnoremap <Leader>ff :edit **/*
nnoremap <Leader>tt :tag 

vnoremap <C-c> :silent w !xsel -ib<CR>

"Abbreviations
cabbr gls `git ls-files`

"Functions
function! ExecAndRestorePos(cmd)
	let save_pos = getpos(".")
	silent execute a:cmd
	call setpos(".", save_pos)
endfunction

if executable('rg')
	set grepprg=rg\ --vimgrep
else
	set grepprg=grep\ -n\ $*
endif

function! Grep(pattern, ...)
	let l:files = a:000
	if a:0 == 0 && system('git rev-parse --is-inside-work-tree') ==# "true\n" 
		let l:files = systemlist('git ls-files')
	endif
	let l:command = join([&grepprg] + [a:pattern] + [expandcmd(join(l:files, ' '))], ' ')
	return system(l:command)
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup quickfix
	autocmd!
 	autocmd FileType qf setlocal wrap
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
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-dispatch'
    Plug 'arcticicestudio/nord-vim'
    Plug 'maxmellon/vim-jsx-pretty', { 'for' : ['javascript', 'javascriptreact'] }
    Plug 'lervag/vimtex', { 'for': 'tex' }
	Plug 'CervEdin/vim-minizinc', { 'for': 'zinc' }
	Plug 'neovimhaskell/haskell-vim', { 'for' : 'haskell' }
    Plug 'dense-analysis/ale', { 'on' : ['ALEToggle'] }
	Plug 'github/copilot.vim', { 'on' : ['Copilot'] }
	Plug 'mhinz/vim-signify', { 'tag': 'legacy', 'on' : ['SignifyToggle'], 'do': ':set signcolumn yes' }
	Plug 'romainl/vim-cool'
    call plug#end()

	"Termdebug
	let g:termdebug_wide=1

    "ALE
    nnoremap <Leader>ca <Cmd>ALECodeAction<CR>
    vnoremap <Leader>ca <Cmd>ALECodeAction<CR>
    nnoremap <Leader>cr <Cmd>ALEFix<CR>
    nnoremap <Leader>rn <Cmd>ALERename<CR>
    nnoremap <Leader>K <Cmd>ALEHover<CR>
    nnoremap <Leader>gd <Cmd>ALEGoToDefinition<CR>
    nnoremap <Leader>gt <Cmd>ALEGoToTypeDefinition<CR>
    nnoremap <Leader>gi <Cmd>ALEGoToImplementation<CR>
    nnoremap <Leader>gr <Cmd>ALEFindReferences -quickfix<CR><CMD>copen<CR>
    nnoremap <Leader>di <Cmd>ALEDetail<CR>
    nnoremap <Leader>ds <Cmd>call ExecAndRestorePos("ALEToggle")<CR><Cmd>echo g:ale_enabled<CR>
    nnoremap <Leader>oi <Cmd>ALEOrganizeImports<CR>
    nnoremap <Leader>ci <Cmd>ALEImport<CR>
    nnoremap <Leader>ss :ALESymbolSearch 
	inoremap <C-K> <Cmd>ALEHover<CR>
	nnoremap <C-K> <Cmd>ALEHover<CR>
	nnoremap [e <Cmd>ALEPrevious<CR>
	nnoremap ]e <Cmd>ALENext<CR>
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
    nnoremap <Leader>gv :Gvdiffsplit <CR>
	nnoremap dgh :diffget //2<CR>
	nnoremap dgl :diffget //3<CR>

	"Signify
    let g:signify_sign_change = "~"
	nnoremap <Leader>ghp <cmd>SignifyHunkPreview<CR>
	nnoremap <Leader>ghu <cmd>SignifyHunkUndo<CR>
	nnoremap <Leader>ghr <cmd>SignifyRefresh<CR>
	nnoremap <Leader>ght <cmd>SignifyToggle<CR>
    omap ic <plug>(signify-motion-inner-pending)
    xmap ic <plug>(signify-motion-inner-visual)
    omap ac <plug>(signify-motion-outer-pending)
    xmap ac <plug>(signify-motion-outer-visual)

endif

"Cosmetic
set fillchars=vert:\│,stl:\―,stlnc:\―
set laststatus=0
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
highlight Visual ctermfg=NONE guifg=NONE
