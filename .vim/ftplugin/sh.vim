setl expandtab
compiler shellcheck

if executable("shfmt")
    nnoremap <Leader>cr <Cmd>call FilterRestorePos("%!shfmt")<CR>
endif

let b:ale_fixers = { 'sh' : ['shfmt'] }
let b:ale_linters = { 'sh' : ['shellcheck'] }


