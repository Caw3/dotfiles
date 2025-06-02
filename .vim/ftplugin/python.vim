set expandtab
let b:ale_linters = ['pyright']
let b:ale_fixers = ['autopep8']

" LSP-servers
if executable('pyright')
	au User lsp_setup call lsp#register_server({
				\ 'name': 'pyright',
				\ 'cmd': {server_info->['pyright']},
				\ 'allowlist': ['python'],
				\ })
endif
