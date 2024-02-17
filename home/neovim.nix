{ config, pkgs, lib, inputs, ... }:
let 
    # Replaced with bulitin upstream
    #plenary-nvim = pkgs.vimUtils.buildVimPlugin {
    #    name = "plenary-nvim";
    #    src = inputs.plenary-nvim;
    #};

    #always installs the latest version
    PlugAndConfig = plug : config : {
        plugin = plug;
        config = config;
    };

    Plug = plug : (PlugAndConfig plug "");
  
    importFile = lib.strings.fileContents;
    
    toggle-lsp-diagnostics-nvim =  pkgs.vimUtils.buildVimPlugin {
        name = "toggle-lsp-diagnostics-nvim";
        src = inputs.vimPlugins_toggle-lsp-diagnostics-nvim;
    };

in {
    home.packages = with pkgs; [
            tree-sitter
            jq curl
            universal-ctags
#nix 
#lsp servers
            rnix-lsp
            nodejs 
# python
            # nodePackages.pyright # not worth
# js & ts 
#nodePackages.typescript-language-server
#rust 
            #rust-analyzer
# lua
            # 
            #sumneko-lua-language-server # not worth
            #lua-ls

            #micromamba
    ];

  programs.neovim = {
      enable = true;
      #package = pkgs.neovim-nightly;
      #package = inputs.neovim-nightly.packages.${pkgs.system}.neovim;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withNodeJs = true;
      withPython3 = true;
      withRuby = true;

      #-- appended to the end of init.vim
      extraConfig = builtins.concatStringsSep "\n" [
         #-- loadSync

         # lua configs 
         ''
lua << EOF
-- loadSync
${importFile ./nvim/telescope.lua}

-- runAsync (deferred lsp configs)
vim.defer_fn(function()
    ${importFile ./nvim/lsp.lua}

    vim.cmd [[
        " defered 
    ]]
end, 70)
EOF
         ''
      ];

      plugins = with pkgs.vimPlugins; [

        #Common dependency for other plugins 
        (PlugAndConfig plenary-nvim  ''
""" IMPORTANT! """ put this at the first to ensure write first !!!
${importFile ../system/vimrc}
${importFile ./nvim/base.vim}
        '')

        (PlugAndConfig ack-vim ''
if executable('rg')
  let g:ackprg = 'rg --vimgrep --smart-case --type-not sql'
endif

" Auto close the Quickfix list after pressing '<enter>' on a list item
let g:ack_autoclose = 0

" Any empty ack search will search for the work the cursor is on
let g:ack_use_cword_for_empty_search = 1

" Don't jump to first match
cnoreabbrev Ack Ack!

nnoremap <Leader>/ :Ack!<Space>

        '')
        
        vim-fugitive
        nvim-web-devicons

        #Fuzzy finder
        telescope-nvim
        telescope-fzf-native-nvim

        #(Plug "nvim-telescope/telescope.nvim")
        #(Plug "kelly-lin/telescope-ag")

        #tree-sitter!
        (PlugAndConfig nvim-treesitter.withAllGrammars ''
lua << EOF
    require'nvim-treesitter.configs'.setup {
      highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,

        -- using old ones
        -- disable = { "markdown" }, 
      },
      indent = { enable = true, },
      incremental_selection = {
        enable = true,
        --keymaps = {
        --  init_selection = "gnn",
        --  node_incremental = "grn",
        --  scope_incremental = "grc",
        --  node_decremental = "grm",
        --},
      },
    }

EOF
        '')

        (PlugAndConfig nvim-treesitter-context ''
lua << EOF
require'treesitter-context'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class',
            'function',
            'method',
            -- 'for', -- These won't appear in the context
            -- 'while',
            -- 'if',
            -- 'switch',
            -- 'case',
        },
        -- Example for a specific filetype.
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        --   rust = {
        --       'impl_item',
        --   },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
    },

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
}
EOF
        '')

        # brackets highlighting
        # (Plug "p00f/nvim-ts-rainbow") 

        # LSP
        nvim-lspconfig
        #(Plug "neovim/nvim-lspconfig")

        # toggle diagnostics
        (PlugAndConfig toggle-lsp-diagnostics-nvim ''
lua << EOF
require'toggle_lsp_diagnostics'.init()
if (not my) then my = {} end
my.toggke = false
my.toggle_diagnostics = function() 
    local toggle_lsp_diagnostics = require'toggle_lsp_diagnostics'
    if my.toggle then 
        toggle_lsp_diagnostics.turn_on_diagnostics()
    else
        toggle_lsp_diagnostics.turn_off_diagnostics()
    end
    my.toggle = not my.toggle
end
EOF

nnoremap <leader>d :lua my.toggle_diagnostics()<CR>
        '')

        # Completion
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline

        # snippets are needed for many language servers
        cmp-vsnip
        vim-vsnip

        friendly-snippets # snippet collection for all languages
        #(Plug "petertriho/cmp-git")

        #TODO r w vimPlugins.lsp_signature-nvim
        lsp_signature-nvim

        #motions
        vim-wordmotion
        clever-f-vim

        #outlines 
        (PlugAndConfig aerial-nvim ''
lua << EOF
require("aerial").setup({
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>")
EOF
        '')

        #bottom line
        (PlugAndConfig lualine-nvim ''
            lua require("lualine").setup({ })
        '')

        # colors & themes
        (PlugAndConfig bufferline-nvim ''
lua << EOF 
require('bufferline').setup {
  options = {
    show_close_icon = true,
    show_buffer_close_icons = false,
    separator_style = "thick",
  },
}
EOF 
        '')

        (PlugAndConfig indentLine ''
let g:indentLine_fileTypeExclude = ['markdown']
        '')

        (PlugAndConfig wilder-nvim ''
lua require('wilder').setup({modes = {':', '/', '?'}})
        '')

        # TODO 
        zenburn

        #(PlugAndConfig vim-LanguageTool ''

        #'')

        (PlugAndConfig vim-easy-align ''
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
        '')

        (PlugAndConfig markdown-preview-nvim ''
let g:mkdp_browser = 'firefox'
nmap <leader>p <Plug>MarkdownPreviewToggle
        '')
      #End of vimPlugins
      ];

       extraPackages = with pkgs; [
        ripgrep
        manix
        git
       ];
  };
}
