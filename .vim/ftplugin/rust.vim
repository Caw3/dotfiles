
setl expandtab
setl shiftwidth=4
setl tabstop=4
setl omnifunc=ale#completion#OmniFunc
compiler cargo

nnoremap <Leader>mm <Cmd>make check<CR>
nnoremap <Leader>mr <Cmd>make! run<CR>
nnoremap <Leader>mt <Cmd>make! test<CR>

let b:ale_linters = ['cargo', 'analyzer']
let b:ale_fixers = ['rustfmt']

let g:termdebugger="rust-gdb"
