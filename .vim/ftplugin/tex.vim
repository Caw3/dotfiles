"Vimtex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_fold_enabled = 1
let g:vimtex_quickfix_mode=0

setlocal spell
setl spelllang=en,sv
nnoremap <localleader>ll <Cmd>VimtexCompile<CR>
