vim.cmd [[
    nnoremap <leader>f <cmd>Telescope find_files<cr>
    nnoremap <leader>G <cmd>Telescope live_grep<cr>
    nnoremap <leader>b <cmd>Telescope buffers<cr>
    nnoremap <leader>h <cmd>Telescope help_tags<cr>
    nnoremap <leader>tt <cmd>Telescope treesitter<cr>
    nnoremap <leader>g :Telescope grep_string search=
]]
local telescope = require('telescope')
--telescope.load_extension('aerial')
telescope.setup({
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--hidden',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = " ",
        initial_mmode = "insert",
        selection_strategy =  "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                mirror = false,
            },
            vertical = {
                mirror = false,
            },
        },
        file_sorter = require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
        shorten_path = true,
        winblend = 0,
        border = {},
        -- botderchars = { '-', '|', '-', '|', '+', '+', '+', '+' },
        color_devicons = true,
        use_less = true,
        set_env = { ['COLORTERM'] = 'truecolor' },
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.view,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    },

    extensions =  {
    }

})
