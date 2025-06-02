setl expandtab
setl shiftwidth=2
setl tabstop=2
compiler shellcheck

if executable("shfmt")
    nnoremap <Leader>cr <Cmd>call ExecAndRestorePos("%!shfmt -i 2")<CR>
endif

nnoremap <Leader>mr <cmd>w !bash<CR>

let b:ale_linters = { 'sh' : ['shellcheck'] }
if executable('bash-language-server')
	augroup LspBash
		autocmd!
		autocmd User lsp_setup call lsp#register_server({
					\ 'name': 'bash-language-server',
					\ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
					\ 'allowlist': ['sh'],
					\ })
	augroup END
endif
