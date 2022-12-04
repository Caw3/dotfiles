
setl expandtab
setl shiftwidth=4
setl tabstop=4
setl omnifunc=ale#completion#OmniFunc
compiler cargo

nnoremap <Leader>mm <Cmd>make! check \| cwindow <CR>
nnoremap <Leader>mr <Cmd>make! ru \| cwindow n<CR>
nnoremap <Leader>ml <Cmd>make! clippy \| cwindow <CR>
nnoremap <Leader>mf <Cmd>make! clippy --fix --allow-dirty \| cwindow <CR>
nnoremap <Leader>mt <Cmd>make! test \| cwindow <CR>
nnoremap <Leader>cL <Cmd>cfile .errors.txt \| cwindow<CR>

let b:ale_linters = ['analyzer']
let b:ale_fixers = ['rustfmt']

let g:termdebugger="rust-gdb"
