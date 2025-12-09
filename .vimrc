filetype plugin indent on
set autoread
set mouse=a
set ttyfast
set wildmenu
set wildoptions=fuzzy,tagfile
set smarttab
set autoindent
set smartindent
set nowrap
set splitbelow
set splitright
set scrolloff=8
set signcolumn=yes
set nu
set incsearch
set hlsearch
set hidden
set noswapfile
set nobackup writebackup
set nocompatible
set backspace=indent,eol,start
set updatetime=100
set completeopt=fuzzy,menuone,popup
set pumheight=40

set wildignore=*.o,node_modules/**,dist/**,build/**
set path=src/,apps/,libs/,test/,e2e/,cmd/,utils/

if !isdirectory("/var/tmp/vim/undo")
    call mkdir("/var/tmp/vim/undo", "p", 0700)
endif
set undodir=/var/tmp/vim/undo
set undofile

"Keymaps
map <Space> <Leader>
inoremap {<cr> {<cr>}<c-o><s-o>
nnoremap <Leader>rr <cmd>e! %<CR>
nnoremap <Leader>nn <cmd>set nu!<CR>
nnoremap <silent> <Leader>* :Grep <C-R><C-W><CR>
nnoremap <Leader>/ :Grep 
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <Leader>s :%s//g<Left><Left>
vnoremap <Leader>s :s//g<Left><Left>
xnoremap * "vy/\V<C-r>=escape(@v,'/\')<CR>
xnoremap <Leader>* "vy:Grep -F <C-r>=shellescape(@v)<CR><CR>
nnoremap <Leader>ff :find **/*
nnoremap <Leader>fe :edit **/*
nnoremap <Leader>tt :tag 

nnoremap <leader>co <cmd>cope<cr>
nnoremap <leader>cc <cmd>cclose<cr>
nnoremap ]q <cmd>cnext<cr>
nnoremap [q <cmd>cprev<cr>
nnoremap ]Q <cmd>clast<cr>
nnoremap [Q <cmd>cfirst<cr>

nnoremap <leader>lo <cmd>lope<cr>
nnoremap <leader>lc <cmd>lclose<cr>
nnoremap ]l <cmd>lnext<cr>
nnoremap [l <cmd>lprev<cr>
nnoremap ]L <cmd>llast<cr>
nnoremap [L <cmd>lfirst<cr>

nnoremap ]t <cmd>tprev<cr>
nnoremap [t <cmd>tnext<cr>

"Functions
function! ExecAndRestorePos(cmd)
	let save_pos = getpos(".")
	silent execute a:cmd
	call setpos(".", save_pos)
endfunction

function! FindGitFiles(cmdarg, cmdcomplete)
    let l:fnames = systemlist('git ls-files')
    return l:fnames->filter('v:val =~? a:cmdarg')
endfunc
set findfunc=FindGitFiles

if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --iglob=!.git/*
    function! Grep(...)
	let l:args = map(copy(a:000), 'expand(v:val)')
	let l:command = &grepprg . ' ' . join(l:args, ' ')
	return system(l:command)
    endfunction
else
    set grepprg=grep\ -Hin
    function! Grep(pattern, ...)
	let l:files = a:000
	if a:0 == 0 && system('git rev-parse --is-inside-work-tree') ==# "true\n" 
	    let l:files = systemlist('git ls-files')
	endif
	let l:files = map(l:files, 'shellescape(v:val)')
	let l:command = join([&grepprg, shellescape(a:pattern)] + l:files, ' ')
	return system(l:command)
    endfunction
endif

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

augroup quickfix
	autocmd!
 	autocmd FileType qf setlocal wrap
	autocmd QuickFixCmdPost cgetexpr cwindow
	autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

if has('timers') && ! exists("g:CheckUpdateStarted")
    let g:CheckUpdateStarted=1
    call timer_start(&g:updatetime,'CheckUpdate')
endif
function! CheckUpdate(timer)
    silent! checktime
    silent! GitGutterAll
    call timer_start(&g:updatetime,'CheckUpdate')
endfunction


silent! packadd cfilter
silent! packadd termdebug

"Plugins
if empty(glob('~/.vim/autoload/plug.vim')) && v:version >= 810 && !has('nvim')
    silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

if filereadable(expand("~/.vim/autoload/plug.vim")) && !has('nvim')
    call plug#begin('~/.vim/vim-plug')
    Plug 'tpope/vim-sleuth'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-rhubarb'
    Plug 'shumphrey/fugitive-gitlab.vim'
    Plug 'arcticicestudio/nord-vim'
    Plug 'maxmellon/vim-jsx-pretty', { 'for' : ['javascript', 'javascriptreact'] }
    Plug 'lervag/vimtex', { 'for': 'tex' }
    Plug 'CervEdin/vim-minizinc', { 'for': 'zinc' }
    Plug 'neovimhaskell/haskell-vim', { 'for' : 'haskell' }
    Plug 'Caw3/ale', { 'on' : ['ALEToggle', 'ALEGoToDefinition', 'ALEFindReferences', 'ALEHover', 'ALERename', 'ALESymbolSearch', 'ALEFix'] }
    Plug 'github/copilot.vim', { 'on' : ['Copilot'] }
    Plug 'airblade/vim-gitgutter'
    Plug 'romainl/vim-cool'
    Plug 'romainl/vim-qf'
    Plug 'romainl/vim-devdocs'
    call plug#end()

    "Vim Cool
    let g:cool_total_matches=1

    "Termdebug
    let g:termdebug_wide=1

    "ALE
    nnoremap <Leader>ca <Cmd>ALECodeAction<CR>
    vnoremap <Leader>ca <Cmd>ALECodeAction<CR>
    nnoremap <Leader>cr <Cmd>ALEFix<CR>
    nnoremap <Leader>rn <Cmd>ALERename<CR>
    nnoremap <Leader>K <Cmd>ALEHover<CR>
    nnoremap <Leader>gd <Cmd>ALEGoToDefinition<CR>
    autocmd! User ale.vim nnoremap <C-]> <Cmd>ALEGoToTypeDefinition<CR>
    nnoremap <Leader>gt <Cmd>ALEGoToTypeDefinition<CR>
    nnoremap <Leader>gi <Cmd>ALEGoToImplementation<CR>
    nnoremap <Leader>gr <Cmd>ALEFindReferences -quickfix<CR><CMD>copen<CR>
    nnoremap gh <Cmd>ALEDetail<CR>
    nnoremap <Leader>ds <Cmd>call ExecAndRestorePos("ALEToggle")<CR><Cmd>echo g:ale_enabled<CR>
    nnoremap <Leader>oi <Cmd>ALEOrganizeImports<CR>
    nnoremap <Leader>ci <Cmd>ALEImport<CR>
    nnoremap <Leader># :ALESymbolSearch 
    nnoremap [e <Cmd>ALEPrevious<CR>
    nnoremap ]e <Cmd>ALENext<CR>
    let g:ale_enabled = 0
    let g:ale_hover_cursor = 0
    let g:ale_set_highlights = 0
    let g:ale_popup_menu_enabled = 1
    let g:ale_completion_autoimport = 1
    let g:ale_echo_msg_format = '[%severity%][%linter%] %s'

    "ALE Linters and Fixers
    let g:ale_linters = {
    \   'java': ['javalsp'],
    \   'javascript': ['tsserver'],
    \   'typescript': ['tsserver'],
    \   'typescriptreact': ['tsserver'],
    \   'python': ['pyright'],
    \   'rust': ['analyzer'],
    \   'c': ['cc'],
    \   'cpp': ['cc'],
    \   'haskell': ['hls'],
    \   'go': ['gopls'],
    \   'sh': ['shellcheck'],
    \   'terraform': ['terraform_ls']
    \}

    let g:ale_fixers = {
    \   'java': ['javalsp'],
    \   'javascript': ['prettier', 'eslint'],
    \   'typescript': ['prettier', 'eslint'],
    \   'typescriptreact': ['prettier', 'eslint'],
    \   'python': ['autopep8'],
    \   'rust': ['rustfmt'],
    \   'haskell': ['ormolu'],
    \   'go': ['gofmt'],
    \   'sh': ['shfmt'],
    \   'terraform': ['terraform']
    \}

    autocmd! User ALELSPStarted set omnifunc=ale#completion#OmniFunc

    "TypeScript Deno support
    autocmd FileType typescript if filereadable('./deno.lock') | let b:ale_fixers = ['deno'] | let b:ale_linters = ['deno'] | endif

    "Dispatch
    nnoremap <Leader>mm <cmd>Make<cr>
    nnoremap <Leader>md :Dispatch -compiler=

    "Fugitive
    augroup ft_fugitve
        autocmd Filetype fugitive setlocal scl=yes
        autocmd Filetype fugitive setlocal nonu
    augroup END
    nnoremap <silent> <Leader>gs :vert Git \|vertical resize 80 <CR>
    nnoremap <Leader>gb :G blame <CR>
    nnoremap <Leader>gl :Gclog<CR>
    vnoremap <leader>gl <ESC>:execute 'vert G log -L' . line("'<") . ',' . line("'>") . ':' . expand('%') <CR>
    nnoremap <Leader>gv :Gvdiffsplit<CR>
    nnoremap <Leader>gV :Gvdiffsplit!<CR>
    nnoremap dgh :diffget //2<CR>
    nnoremap dgl :diffget //3<CR>

    let g:gitgutter_show_msg_on_hunk_jumping = 1
    nmap <Leader>ghs <Plug>(GitGutterStageHunk)
    nmap <Leader>ghu <Plug>(GitGutterUndoHunk)
    nmap <Leader>ghp <Plug>(GitGutterPreviewHunk)
    nmap <Leader>ght :GitGutterToggle<CR>
    omap ih <Plug>(GitGutterTextObjectInnerPending)
    omap ah <Plug>(GitGutterTextObjectOuterPending)
    xmap ih <Plug>(GitGutterTextObjectInnerVisual)
    xmap ah <Plug>(GitGutterTextObjectOuterVisual)
    let g:gitgutter_sign_added = '│'
    let g:gitgutter_sign_modified = '│'
    let g:gitgutter_sign_removed = '│'

endif

"Cosmetic
set fillchars=vert:\│,stl:\―,stlnc:\―
set laststatus=0
silent! colorscheme nord
hi VertSplit ctermbg=NONE 
hi link IncSearch LineNr
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
highlight Search ctermfg=6 ctermbg=8
highlight CurSearch ctermfg=5 ctermbg=8


autocmd FileType javascript setlocal shiftwidth=2 expandtab
autocmd FileType typescript setlocal shiftwidth=2 expandtab
autocmd FileType css setlocal ofu=csscomplete#CompleteCSS
autocmd FileType markdown setlocal textwidth=80 noexpandtab spell spelllang=en_us,sv
autocmd FileType sh compiler shellcheck

augroup ft_tex
    autocmd!
    autocmd FileType tex call s:TexSetup()
augroup END

function! s:TexSetup()
    let g:tex_flavor = 'latex'
    let g:vimtex_fold_enabled = 1
    let g:vimtex_quickfix_mode = 0
    setlocal spell
    setlocal spelllang=en,sv
endfunction
