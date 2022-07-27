require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true, },
  rainbow = {
      enable = true,
      extended_mode = true,
      -- prevents lagging in large files
      max_file_lines = 1000,
  },
}

require('bufferline').setup {
  options = {
    show_close_icon = false,
    show_buffer_close_icons = false,
    separator_style = "thick",
  },
  -- TODO change highlights based on base16
  --highlights = {
    --fill = {
        --guifg = '#3B4252',
        --guibg = '#3B4252',
    --},
  --},
}

local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})
--wilder.set_option('renderer', wilder.renderer_mux({
--  [':'] = wilder.popupmenu_renderer({
--    highlighter = wilder.basic_highlighter(),
--  }),
--  ['/'] = wilder.wildmenu_renderer({
--    highlighter = wilder.basic_highlighter(),
--  }),
--}))
--
require("aerial").setup({
  on_attach = function(bufnr)
    -- Toggle the aerial window with <leader>a
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>AerialToggle!<CR>', {})
    -- Jump forwards/backwards with '{' and '}'
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '{', '<cmd>AerialPrev<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '}', '<cmd>AerialNext<CR>', {})
    -- Jump up the tree with '[[' or ']]'
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>AerialPrevUp<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>AerialNextUp<CR>', {})
  end
})

require("lualine").setup({
  sections = {
    lualine_x = { "aerial" },

    -- Or you can customize it
    lualine_y = { "aerial",
      -- The separator to be used to separate symbols in status line.
      sep = ' ) ',

      -- The number of symbols to render top-down. In order to render only 'N' last
      -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
      -- be used in order to render only current symbol.
      depth = nil,

      -- When 'dense' mode is on, icons are not rendered near their symbols. Only
      -- a single icon that represents the kind of current symbol is rendered at
      -- the beginning of status line.
      dense = false,

      -- The separator to be used to separate symbols in dense mode.
      dense_sep = '.',
    },
  },
})
