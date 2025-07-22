filetype plugin indent on
set autoread
set mouse=a
set ttyfast
set wildmenu
set wildoptions=fuzzy,tagfile
set path=packages/,src/,test/,config/
set path+=~/.dotfiles
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
set completeopt=fuzzy,menu,popup
set pumheight=40

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
nnoremap <Leader>rr <cmd>e! %<CR>

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
    Plug 'arcticicestudio/nord-vim'
    Plug 'maxmellon/vim-jsx-pretty', { 'for' : ['javascript', 'javascriptreact'] }
    Plug 'lervag/vimtex', { 'for': 'tex' }
    Plug 'CervEdin/vim-minizinc', { 'for': 'zinc' }
    Plug 'neovimhaskell/haskell-vim', { 'for' : 'haskell' }
    Plug 'Caw3/ale', { 'on' : ['ALEToggle', '<Plug>ale#completion#OmniFunc', 'ALEGoToDefinition', 'ALEFindReferences', 'ALEHover', 'ALERename', 'ALESymbolSearch'] }
    Plug 'github/copilot.vim', { 'on' : ['Copilot'] }
    if has('patch-8.0.902')
	Plug 'mhinz/vim-signify'
    else
	Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
    endif
    Plug 'romainl/vim-cool'
    Plug 'romainl/vim-qf'
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
    set omnifunc=ale#completion#OmniFunc
    if !exists("tags")
	nnoremap <C-]> <cmd>ALEGoToDefinition<cr>
    endif

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
    \   'sh': ['shellcheck']
    \}

    let g:ale_fixers = {
    \   'java': ['javalsp'],
    \   'javascript': ['eslint'],
    \   'typescript': ['tsserver'],
    \   'typescriptreact': ['tsserver'],
    \   'python': ['autopep8'],
    \   'rust': ['rustfmt'],
    \   'haskell': ['ormolu'],
    \   'go': ['gofmt'],
    \   'sh': ['shfmt']
    \}

    "TypeScript Deno support
    autocmd FileType typescript if filereadable('./deno.lock') | let b:ale_fixers = ['deno'] | let b:ale_linters = ['deno'] | endif

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
    let g:signify_sign_change = "│"
    let g:signify_sign_add = "│"
    let g:signify_sign_delete = "│"
    nnoremap <Leader>ghp <cmd>SignifyHunkPreview<CR>
    nnoremap <Leader>ghu <cmd>SignifyHunkUndo<CR>
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
hi! link WinSeparator LineNr
hi! link StatusLineTermNC VertSplit
hi! link StatusLineTerm LineNr
hi! link debugPC Visual
hi! link debugBreakpoint TODO
hi! link QuickFixLine Visual
hi! link qfError Number 
hi! link qfFilename Conditional
highlight Visual ctermfg=NONE guifg=NONE


"Filetypes
""C++ 
augroup ft_cpp
    autocmd!
    autocmd FileType cpp call s:CppSetup()
augroup END

function! s:CppSetup()
    if executable("astyle")
        nnoremap <buffer> <Leader>cr <Cmd>call ExecAndRestorePos("%!astyle")<CR>
    endif
    nnoremap <buffer> <Leader>mr <Cmd>!./a.out<CR>
endfunction

"Go 
augroup ft_go
    autocmd!
    autocmd FileType go call s:GoSetup()
augroup END

function! s:GoSetup()
    compiler go
    if executable("gofmt")
        nnoremap <buffer> <Leader>cr <Cmd>call ExecAndRestorePos("%!gofmt")<CR>
    endif
    nnoremap <buffer> <Leader>mr <Cmd>!go run %<CR>
    nnoremap <buffer> <Leader>mt <Cmd>!go test<CR>
endfunction

"Haskell (stack) 
augroup ft_haskell
    autocmd!
    autocmd FileType haskell call s:HaskellSetup()
augroup END

function! s:HaskellSetup()
    compiler stack
    let &l:makeprg = 'stack'
    if executable("ormolu")
        nnoremap <buffer> <Leader>cr <Cmd>call ExecAndRestorePos("%!ormolu --stdin-input-file %")<CR>
    endif
    nnoremap <buffer> <Leader>mm <Cmd>make! build | cwindow<CR>
    nnoremap <buffer> <Leader>mr <Cmd>make! run | cwindow<CR>
    nnoremap <buffer> <Leader>cL <Cmd>GhcidErrors<CR>
    command! GhcidErrors let &errorformat = '%f:%l:%c:%m,%f:%l:%c-%n:%m,%f:(%l\,%c)-%m' | cexpr [] | cgetfile | compiler stack | cfirst
endfunction


"Java 
augroup ft_java
    autocmd!
    autocmd FileType java compiler javac
augroup END

"JavaScript 
augroup ft_javascript
    autocmd!
    autocmd FileType javascript compiler eslint
    autocmd FileType javascript source $HOME/.vim/ftplugin/javascript.vim
augroup END

"CSS (example line, likely misplaced) 
autocmd FileType css setlocal ofu=csscomplete#CompleteCSS

"markdown
autocmd FileType markdown setlocal textwidth=80 noexpandtab spell spelllang=en_us,sv

"Perl 
augroup ft_perl
    autocmd!
    autocmd FileType perl call s:PerlSetup()
augroup END

function! s:PerlSetup()
    compiler perl
    if executable("perltidy")
        nnoremap <buffer> <Leader>cr <Cmd>call ExecAndRestorePos("%!perltidy")<CR>
    endif
    nnoremap <buffer> <Leader>mm <cmd>Make<CR>
endfunction

"Rust 
augroup ft_rust
    autocmd!
    autocmd FileType rust call s:RustSetup()
augroup END

function! s:RustSetup()
    compiler cargo
    nnoremap <buffer> <Leader>mm <Cmd>Make! check | cwindow<CR>
    nnoremap <buffer> <Leader>mr <Cmd>Make! run | cwindow<CR>
    nnoremap <buffer> <Leader>ml <Cmd>Make! clippy | cwindow<CR>
    nnoremap <buffer> <Leader>mf <Cmd>Make! clippy --fix --allow-dirty | cwindow<CR>
    nnoremap <buffer> <Leader>mt <Cmd>Make! test | cwindow<CR>
    nnoremap <buffer> <Leader>cL <Cmd>cfile .errors.txt | cwindow<CR>
    nnoremap <buffer> <Leader>dt <Cmd>call RustDebugTest()<Cr>
    nnoremap <buffer> <Leader>dr <Cmd>call RustDebugRun()<Cr>
    nnoremap <buffer> <Leader>db <Cmd>call RustDebug()<Cr>
    let g:termdebugger = "rust-gdb"
endfunction

function! RustDebug()
    let path = trim(system("find target/debug -maxdepth 1 -type f -executable"))
    execute 'Termdebug' path
endfunction

function! RustDebugRun()
    call RustDebug()
    wincmd h
    normal j
    execute 'Break'
    execute 'Run'
endfunction

function! RustDebugTest()
    let test = expand("<cword>")
    let regex = 's/.*(\(.*\))/\1/'
    let path = trim(system("cargo test " . test . " --no-run 2>&1 | tail -n 1 | sed '" . regex . "'"))
    execute 'Termdebug' path
    wincmd h
    normal j
    execute 'Break'
    execute 'Run'
endfunction

"Shell scripts 
augroup ft_sh
    autocmd!
    autocmd FileType sh call s:ShellSetup()
augroup END

function! s:ShellSetup()
    compiler shellcheck
    if executable("shfmt")
        nnoremap <buffer> <Leader>cr <Cmd>call ExecAndRestorePos("%!shfmt -i 2")<CR>
    endif
    nnoremap <buffer> <Leader>mr <cmd>w !bash<CR>
endfunction

"LaTeX / VimTeX 
augroup ft_tex
    autocmd!
    autocmd FileType tex call s:TexSetup()
augroup END

function! s:TexSetup()
    let g:tex_flavor = 'latex'
    let g:vimtex_view_method = 'zathura'
    let g:vimtex_fold_enabled = 1
    let g:vimtex_quickfix_mode = 0
    setlocal spell
    setlocal spelllang=en,sv
    nnoremap <buffer> <localleader>ll <Cmd>VimtexCompile<CR>
endfunction
