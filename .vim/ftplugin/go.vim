compiler go

if executable("gofmt")
    nnoremap <Leader>cr <Cmd>call ExecAndRestorePos("%!gofmt")<CR>
endif
    nnoremap <Leader>mr <Cmd>!go run %<CR>
    nnoremap <Leader>mt <Cmd>!go test<CR>
