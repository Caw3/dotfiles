set noexpandtab
setl omnifunc=ale#completion#OmniFunc
compiler go

let b:ale_linters = { 'go' : ['gopls'] }
let b:ale_fixers = { 'go' : ['gofmt'] }
