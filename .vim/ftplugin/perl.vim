set expandtab
set shiftwidth=4
set tabstop=4
compiler perl

if executable("perltidy")
    nnoremap <Leader>cr <Cmd>call ExecAndRestorePos("%!perltidy")<CR>
endif

nnoremap <Leader>mr <cmd>w !perl<CR>
