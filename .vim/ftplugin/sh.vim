setl expandtab
setl shiftwidth=2
setl tabstop=2
compiler shellcheck

if executable("shfmt")
    nnoremap <Leader>cr <Cmd>call FilterRestorePos("%!shfmt -i 2")<CR>
endif

let b:ale_fixers = { 'sh' : ['shfmt'] }
let b:ale_linters = { 'sh' : ['shellcheck'] }
