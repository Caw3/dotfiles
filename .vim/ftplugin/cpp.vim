if executable("astyle")
    nnoremap <Leader>cr <Cmd>call ExecAndRestorePos("%!astyle")<CR>
endif

let b:ale_linters = { 'c' : ['cc'], 'cpp': ['cc'] }
nnoremap <Leader>mr <Cmd>!./a.out<CR>
