require("indent_blankline").setup {
    show_current_context = false,
    show_current_context_start = false,
}

vim.cmd('let g:indent_blankline_filetype_exclude = ["zsh","man","NvimTree","lspinfo","packer","checkhealth","help","Outline"]')
