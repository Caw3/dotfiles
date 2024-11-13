source $HOME/.vim/ftplugin/javascript.vim

if filereadable('./deno.lock')
	let b:ale_fixers = ['deno']
	let b:ale_linters = ['deno']
endif
