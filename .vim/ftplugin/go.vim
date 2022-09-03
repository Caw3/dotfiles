setl noexpandtab
setl shiftwidth=4
setl tabstop=4
setl omnifunc=ale#completion#OmniFunc
compiler go

if executable("gofmt")
    nnoremap <Leader>cr <Cmd>call ExecAndRestorePos("%!gofmt")<CR>
endif
    nnoremap <Leader>mr <Cmd>!go run %<CR>
    nnoremap <Leader>mt <Cmd>!go test<CR>

let b:ale_linters = { 'go' : ['gopls'] }
