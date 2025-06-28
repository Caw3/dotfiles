if executable("astyle")
    nnoremap <Leader>cr <Cmd>call ExecAndRestorePos("%!astyle")<CR>
endif

nnoremap <Leader>mr <Cmd>!./a.out<CR>
