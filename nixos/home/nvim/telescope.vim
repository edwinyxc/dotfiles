nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>G <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>tt <cmd>Telescope treesitter<cr>
nnoremap <leader>g :Telescope grep_string search=

lua << EOF
local telescope = require('telescope')
    telescope.load_extension('aerial')
    telescope.setup({
        extensions =  {
            aerial = {
                show_nesting = true
            }
        }

    })
EOF
