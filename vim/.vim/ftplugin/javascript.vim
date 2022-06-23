setlocal expandtab
setlocal tabstop=2
setlocal shiftwidth=2
compiler eslint

let b:ale_linters = ['eslint']
let b:ale_fixers = ['standard']
