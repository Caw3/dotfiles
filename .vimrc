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
set updatetime=100

if !has('nvim')
    if !isdirectory("/var/tmp/vim/undo")
	call mkdir("/var/tmp/vim/undo", "p", 0700)
    endif
    set undodir=/var/tmp/vim/undo
    set undofile
endif

"Keymaps
map <Space> <Leader>
inoremap {<cr> {<cr>}<c-o><s-o>
inoremap <Leader>rr <cmd>e! %<CR>

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

au CursorHold,CursorHoldI * checktime
au FocusGained,BufEnter * checktime

packadd cfilter
packadd termdebug

"Plugins
if empty(glob('~/.vim/autoload/plug.vim')) && v:version >= 810 && !has('nvim')
    silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

if filereadable(expand("~/.vim/autoload/plug.vim")) && !has('nvim')
    call plug#begin('~/.vim/vim-plug')
	Plug 'prabirshrestha/vim-lsp'
	Plug 'rhysd/vim-lsp-ale'
	Plug 'Caw3/ale'

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
    Plug 'github/copilot.vim', { 'on' : ['Copilot'] }
    if has('patch-8.0.902')
		Plug 'mhinz/vim-signify', { 'on' : ['SignifyToggle'] }
    else
		Plug 'mhinz/vim-signify', { 'tag': 'legacy', 'on' : ['SignifyToggle'] }
    endif
    Plug 'romainl/vim-cool'
    Plug 'romainl/vim-qf'
    call plug#end()

	function! s:on_lsp_buffer_enabled() abort
		setlocal omnifunc=lsp#complete
		if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
		nmap <buffer> <leader>gd <plug>(lsp-definition)
		nmap <buffer> <leader>@ <plug>(lsp-document-symbol-search)
		nmap <buffer> <leader># <plug>(lsp-workspace-symbol-search)
		nmap <buffer> <leader>ss <plug>(lsp-workspace-symbol)
		nmap <buffer> <leader>gr <plug>(lsp-references)
		nmap <buffer> <leader>gi <plug>(lsp-implementation)
		nmap <buffer> <leader>gt <plug>(lsp-type-definition)
		nmap <buffer> <leader>rn <plug>(lsp-rename)
		nmap <buffer> [e <plug>(lsp-previous-diagnostic)
		nmap <buffer> ]e <plug>(lsp-next-diagnostic)
		nmap <buffer> K <plug>(lsp-hover)
		nmap <buffer> <leader>ca <plug>(lsp-code-action)

		let g:lsp_format_sync_timeout = 1000
		let g:lsp_document_code_action_signs_enabled = 0
		let g:lsp_document_code_action_signs_enabled = 0
		let g:lsp_signature_help_delay = 1
	endfunction

	augroup lsp_install
		au!
		" call s:on_lsp_buffer_enabled only for languages that has the server registered.
		autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
	augroup END

	let g:lsp_plugins_loaded = 0
	let g:lsp_enabled = 0
	let g:ale_enabled = 0

	function! ToggleLSP()
		call ToggleSignifyAndSignColumn()
		if !exists('g:lsp_enabled') || g:lsp_enabled == 0
			" Enable vim-lsp and ALE
			let g:lsp_enabled = 1
			let g:ale_enabled = 1
			echo "LSP client enabled"
		else
			" Disable vim-lsp and ALE
			let g:lsp_enabled = 0
			let g:ale_enabled = 0
			echo "LSP client disabled"
		endif
	endfunction

	noremap <leader>ds <cmd>call ToggleLSP()<CR>
	nnoremap <silent> <leader>di <cmd>ALEDetail<CR>

	noremap <leader>di <cmd>ALEDetail<CR>
	noremap <leader>cr <cmd>ALEFix<CR>
    let g:ale_hover_cursor = 0
    let g:ale_set_highlights = 0
	let g:ale_disable_lsp = 1

    "Vim Cool
    let g:cool_total_matches=1

    "Termdebug
    let g:termdebug_wide=1

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
    nnoremap <Leader>gV :Gvdiffsplit! <CR>
    nnoremap <Leader>gm :G mergetool <CR>
	nnoremap dgh :diffget //2<CR>
	nnoremap dgl :diffget //3<CR>

	"Signify
	function! ToggleSignifyAndSignColumn()
		if &signcolumn ==# 'yes'
			set signcolumn=auto
		else
			set signcolumn=yes
		endif
		SignifyToggle
	endfunction
    let g:signify_sign_change = "│"
    let g:signify_sign_add = "│"
    let g:signify_sign_delete = "│"
	nnoremap <Leader>ghp <cmd>SignifyHunkDiff<CR>
	nnoremap <Leader>ghu <cmd>SignifyHunkUndo<CR>
	nnoremap <Leader>ght <cmd>call ToggleSignifyAndSignColumn()<CR>
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
hi! link WinSeparator LineNr
hi! link StatusLineTermNC VertSplit
hi! link StatusLineTerm LineNr
hi! link debugPC Visual
hi! link debugBreakpoint TODO
hi! link QuickFixLine Visual
hi! link qfError Number 
hi! link qfFilename Conditional
highlight Visual ctermfg=NONE guifg=NONE
