setlocal expandtab
setlocal tabstop=2
setlocal shiftwidth=2
setlocal include=from
compiler eslint

setlocal omnifunc=ale#completion#OmniFunc
let b:ale_linters = ['tsserver']
let b:ale_fixers = ['eslint']
