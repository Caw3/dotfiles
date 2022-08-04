set expandtab
set shiftwidth=4
set tabstop=4
compiler perl

if executable("perlcritic")
    compiler perlcritic
endif

if executable("perltidy")
    nnoremap <Leader>cr <Cmd>call FilterRestorePos("%!perltidy")<CR>
endif

nnoremap <Leader>mr <cmd>w !perl<CR>
