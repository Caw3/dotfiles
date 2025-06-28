compiler shellcheck

if executable("shfmt")
    nnoremap <Leader>cr <Cmd>call ExecAndRestorePos("%!shfmt -i 2")<CR>
endif

nnoremap <Leader>mr <cmd>w !bash<CR>
