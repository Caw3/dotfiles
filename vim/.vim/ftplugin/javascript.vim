setlocal expandtab
setlocal tabstop=2
setlocal shiftwidth=2
compiler eslint

setlocal include=from
let b:ale_linters = ['eslint']
let b:ale_fixers = ['standard', 'importjs']
