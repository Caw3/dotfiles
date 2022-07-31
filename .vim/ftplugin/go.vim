setl noexpandtab
setl shiftwidth=4
setl tabstop=4
setl omnifunc=ale#completion#OmniFunc
compiler go

function! FilterAndRestore(cmd)
	let save_pos = getpos(".")
	silent execute a:cmd
	call setpos(".", save_pos)
endfunction

augroup format_save
	autocmd BufWritePre *.go call FilterAndRestore("%!gofmt")
augroup END

nnoremap <Leader>cr <Cmd>call FilterAndRestore("%!gofmt")<CR>

let b:ale_linters = { 'go' : ['gopls'] }
let b:ale_fixers = { 'go' : ['gofmt'] }
