vim.g.jupytext_fmt = "py:percent"
vim.g.ipy_celldef = "# %%"
nmap("<leader>jqt", ':call jobstart("jupyter qtconsole --JupyterWidget.include_other_output=True --style native")<CR>')
nmap("<leader>jqk", ":IPython --existing --no-window <CR>")
nmap("<leader>jk", ":IPython<CR><C-w>H")
nmap("<leader>jc", ":call IPyRunCell()<CR>")
vim.cmd("nmap <leader>ja <Plug>(IPy-RunAll)")
vim.cmd("nmap <leader>jt <Plug>(IPy-Terminate)")
