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
            rust-analyzer
# lua
            # 
            #sumneko-lua-language-server # not worth
            #lua-ls

            micromamba
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
${importFile ./vimrc}
${importFile ./nvim/base.vim}
        '')
        
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
        disable = { "markdown" }, 
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

        (PlugAndConfig vim-markdown ''
let g:vim_markdown_conceal = 2
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_math = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_autowrite = 1
let g:vim_markdown_edit_url_in = 'tab'
let g:vim_markdown_follow_anchor = 1
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

        (PlugAndConfig symbols-outline-nvim ''
lua << EOF
vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = true,
    position = 'right',
    relative_width = true,
    width = 25,
    auto_close = false,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    preview_bg_highlight = 'Pmenu',
    keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = {"<Esc>", "q"},
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
    },
    lsp_blacklist = {},
    symbol_blacklist = {},
    symbols = {
        File = {icon = "", hl = "TSURI"},
        Module = {icon = "", hl = "TSNamespace"},
        Namespace = {icon = "", hl = "TSNamespace"},
        Package = {icon = "", hl = "TSNamespace"},
        Class = {icon = "𝓒", hl = "TSType"},
        Method = {icon = "ƒ", hl = "TSMethod"},
        Property = {icon = "", hl = "TSMethod"},
        Field = {icon = "", hl = "TSField"},
        Constructor = {icon = "", hl = "TSConstructor"},
        Enum = {icon = "ℰ", hl = "TSType"},
        Interface = {icon = "ﰮ", hl = "TSType"},
        Function = {icon = "", hl = "TSFunction"},
        Variable = {icon = "", hl = "TSConstant"},
        Constant = {icon = "", hl = "TSConstant"},
        String = {icon = "𝓐", hl = "TSString"},
        Number = {icon = "#", hl = "TSNumber"},
        Boolean = {icon = "⊨", hl = "TSBoolean"},
        Array = {icon = "", hl = "TSConstant"},
        Object = {icon = "⦿", hl = "TSType"},
        Key = {icon = "🔐", hl = "TSType"},
        Null = {icon = "NULL", hl = "TSType"},
        EnumMember = {icon = "", hl = "TSField"},
        Struct = {icon = "𝓢", hl = "TSType"},
        Event = {icon = "🗲", hl = "TSType"},
        Operator = {icon = "+", hl = "TSOperator"},
        TypeParameter = {icon = "𝙏", hl = "TSParameter"}
    }
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
        #(Plug "stevearc/aerial.nvim")

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

        indentLine

        (PlugAndConfig wilder-nvim ''
            lua require('wilder').setup({modes = {':', '/', '?'}})
        '')

        # TODO 
        zenburn

        (PlugAndConfig vim-easy-align ''
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
        '')
      ];

       extraPackages = with pkgs; [
        ripgrep
        manix
        git
       ];
  };
}