cnoremap <C-E> <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>fz :FZF -m<CR>
nnoremap <silent> <leader>f :Files<CR>
"Recovery commands from history through FZF
nmap <leader>y :History:<CR>

