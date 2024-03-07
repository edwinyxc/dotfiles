vim.cmd [[
    nnoremap <leader>f <cmd>Telescope find_files<cr>
    nnoremap <leader>G <cmd>Telescope live_grep<cr>
    nnoremap <leader>b <cmd>Telescope buffers<cr>
    nnoremap <leader>h <cmd>Telescope help_tags<cr>
    nnoremap <leader>tt <cmd>Telescope treesitter<cr>
    nnoremap <leader>g :Telescope grep_string search=
    " C for citations
    nnoremap <leader>c <cmd>Telescope bibtex<cr>
]]
local telescope = require('telescope')
--telescope.load_extension('aerial')
telescope.load_extension('fzf')
telescope.load_extension('bibtex')
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
        bibtex = {
            depth = 1,
            -- Depth for the *.bib file
            global_files = { '$HOME/zotero.bib' },
            -- Path to global bibliographies (placed outside of the project)
            search_keys = { 'author', 'year', 'title' },
            -- Define the search keys to use in the picker
            citation_format = '{{author}} ({{year}}), {{title}}.',
            -- Template for the formatted citation
            citation_trim_firstname = true,
            -- Only use initials for the authors first name
            citation_max_auth = 2,
            -- Max number of authors to write in the formatted citation
            -- following authors will be replaced by "et al."
            custom_formats = {
                { id = 'citet', cite_maker = '\\citet{%s}' }
            },
            -- Custom format for citation label
            format = 'citet',
            -- Format to use for citation label.
            -- Try to match the filetype by default, or use 'plain'
            context = true,
            -- Context awareness disabled by default
            context_fallback = true,
            -- Fallback to global/directory .bib files if context not found
            -- This setting has no effect if context = false
            wrap = false,
            -- Wrapping in the preview window is disabled by default
        },
    },
})
