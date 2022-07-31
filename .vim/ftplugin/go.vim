setl noexpandtab
setl shiftwidth=4
setl tabstop=4
setl omnifunc=ale#completion#OmniFunc
compiler go

if executable("gofmt")
    augroup format_save
        autocmd BufWritePre *.go call FilterRestorePos("%!gofmt")
    augroup END
    nnoremap <Leader>cr <Cmd>call FilterRestorePos("%!gofmt")<CR>
endif

let b:ale_linters = { 'go' : ['gopls'] }
let b:ale_fixers = { 'go' : ['gofmt'] }
