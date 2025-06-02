setlocal expandtab
setlocal tabstop=2
setlocal shiftwidth=2
setlocal include=from
compiler eslint
let b:ale_fixers = ['eslint']
