set expandtab
set shiftwidth=2
compiler stack
let &makeprg='stack'

if executable("ormolu")
    nnoremap <Leader>cr <Cmd>call ExecAndRestorePos("%!ormolu --stdin-input-file %")<CR>
endif
let b:ale_linters = ['hls']

nnoremap <Leader>mm <Cmd>make! build \| cwindow <CR>
nnoremap <Leader>mr <Cmd>make! run \| cwindow<CR>
command! GhcidErrors let &errorformat = '%f:%l:%c:%m,%f:%l:%c-%n:%m,%f:(%l\,%c)-%m' | cexpr [] | cgetfile | compiler stack | cfirst
nnoremap <Leader>cL <Cmd>GhcidErrors<CR>
