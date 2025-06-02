source $HOME/.vim/ftplugin/javascript.vim

function! s:is_deno_project() abort
	return filereadable('./deno.json') || filereadable('./deno.jsonc') || filereadable('./deno.lock')
endfunction

if s:is_deno_project()
	let b:ale_fixers = ['deno']
	let b:ale_linters = ['deno']
endif


if executable('typescript-language-server') && !s:is_deno_project()
	au User lsp_setup call lsp#register_server({
				\ 'name': 'typescript-language-server',
				\ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
				\ 'root_uri': {server_info->lsp#utils#path_to_uri(
				\     lsp#utils#find_nearest_parent_file_directory(
				\         lsp#utils#get_buffer_path(), 'tsconfig.json'))},
				\ 'whitelist': ['typescript', 'typescript.tsx', 'typescriptreact'],
				\ })
endif

if executable('deno') && s:is_deno_project()
	au User lsp_setup call lsp#register_server({
				\ 'name': 'denols',
				\ 'cmd': {server_info->['deno', 'lsp']},
				\ 'allowlist': ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
				\ 'initialization_options': {
				\   'enable': v:true,
				\   'lint': v:true,
				\   'unstable': v:false,
				\ },
				\ 'root_uri': {server_info->lsp#utils#path_to_uri(
				\     lsp#utils#find_nearest_parent_file_directory(
				\         lsp#utils#get_buffer_path(), 'deno.json'))},
				\ })
endif
