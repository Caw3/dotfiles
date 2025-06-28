setl expandtab
setl shiftwidth=4
setl tabstop=4
compiler cargo

nnoremap <Leader>mm <Cmd>make! check \| cwindow <CR>
nnoremap <Leader>mr <Cmd>make! run \| cwindow n<CR>
nnoremap <Leader>ml <Cmd>make! clippy \| cwindow <CR>
nnoremap <Leader>mf <Cmd>make! clippy --fix --allow-dirty \| cwindow <CR>
nnoremap <Leader>mt <Cmd>make! test \| cwindow <CR>
nnoremap <Leader>cL <Cmd>cfile .errors.txt \| cwindow<CR>

let g:termdebugger="rust-gdb"

function! RustDebug()
    let path = trim(system("find target/debug -maxdepth 1 -type f -executable"))
	execute 'Termdebug' path
endfunction

function! RustDebugRun()
	call RustDebug()
	wincmd h
	normal j
	execute 'Break'
	execute 'Run'
endfunction

function! RustDebugTest()
	let test = expand("<cword>")
	let regex = 's/.*(\(.*\))/\1/'
    let path = trim(system("cargo test " . test . " --no-run 2>&1 | tail -n 1 | sed '" . regex . "'"))
	execute 'Termdebug' path
	wincmd h
	normal j
	execute 'Break'
	execute 'Run'
endfunction

nnoremap <Leader>dt <Cmd>call RustDebugTest()<Cr>
nnoremap <Leader>dr <Cmd>call RustDebugRun()<Cr>
nnoremap <Leader>db <Cmd>call RustDebug()<Cr>
