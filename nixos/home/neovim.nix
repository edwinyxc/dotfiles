{ config, pkgs, lib, ... }:
let 
    #installs a vim plugin from git with a given tag /branch
    #TODO make some inline setup functinality
    PlugGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "${lib.strings.sanitizeDerivationName repo}";
        version = ref;
        src = builtins.fetchGit {
            url = "https://github.com/${repo}.git";
            ref = ref;
        };
    };

    #always installs the latest version
    PlugAndConfig = repo : config : {
        plugin = (PlugGit "HEAD" repo);
        config = config;
    };

    Plug = repo : (PlugAndConfig repo "");
  
  importFile = lib.strings.fileContents;

in {
  nixpkgs.overlays = [
      (import (builtins.fetchTarball {
          url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
      }))
  ];

  programs.neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      viAlias = true;
      vimAlias = true;

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

-- runAsync
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
        #IMPORTANT! put this at the first to ensure write first
        (PlugAndConfig "nvim-lua/plenary.nvim" ''
         ${importFile ./vimrc}
         ${importFile ./nvim/base.vim}
        '')
        (Plug "kyazdani42/nvim-web-devicons")

        #Fuzzy finder
        (Plug "nvim-telescope/telescope.nvim")
        #(Plug "kelly-lin/telescope-ag")


        #tree-sitter!
        {
            plugin = (nvim-treesitter.withPlugins (
                        plugins: with plugins; [
                        tree-sitter-nix
                        tree-sitter-lua
                        tree-sitter-python
                        tree-sitter-rust
                        tree-sitter-c
                        tree-sitter-cpp
                        # tree-sitter-llvm
                        tree-sitter-java
                        tree-sitter-javascript
                        tree-sitter-typescript
                        tree-sitter-dockerfile
                        tree-sitter-make
                        tree-sitter-markdown
                        tree-sitter-json
                        tree-sitter-yaml
                        tree-sitter-toml
                        tree-sitter-http
                        tree-sitter-css
                        ]
            ));

            config = ''
lua << EOF
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
            '';

        }

        (PlugAndConfig "nvim-treesitter/nvim-treesitter-context" ''
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

        (PlugAndConfig "simrat39/symbols-outline.nvim" ''
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
        (Plug "neovim/nvim-lspconfig")

        # toggle diagnostics
        (PlugAndConfig "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim" ''
lua << EOF
require'toggle_lsp_diagnostics'.init()
my = {
    toggle = false
}
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
        (Plug "hrsh7th/nvim-cmp")
        (Plug "hrsh7th/cmp-nvim-lsp")
        (Plug "hrsh7th/cmp-buffer")
        (Plug "hrsh7th/cmp-path")
        (Plug "hrsh7th/cmp-cmdline")

        # snippets are needed for many language servers
        (Plug "hrsh7th/cmp-vsnip")
        (Plug "hrsh7th/vim-vsnip")

        (Plug "rafamadriz/friendly-snippets") # snippet collection for all languages
        #(Plug "petertriho/cmp-git")

        (Plug "ray-x/lsp_signature.nvim" )

        #motions
        (Plug"chaoren/vim-wordmotion")
        (Plug "rhysd/clever-f.vim")

        #outlines 
        #(Plug "stevearc/aerial.nvim")

        #bottom line
        (PlugAndConfig "nvim-lualine/lualine.nvim" ''
            lua require("lualine").setup({ })
        '')

        # colors & themes
        (PlugAndConfig "akinsho/nvim-bufferline.lua" ''
            lua << EOF 
            require('bufferline').setup {
              options = {
                show_close_icon = false,
                show_buffer_close_icons = false,
                separator_style = "thick",
              },
            }
            EOF 
        '')
        (Plug "Yggdroot/indentLine")
        (PlugAndConfig "gelguy/wilder.nvim" ''
            lua require('wilder').setup({modes = {':', '/', '?'}})
        '')

        #(Plug "tomasr/molokai")
        #(Plug "nanotech/jellybeans.vim")
        (Plug "jnurmine/Zenburn")

        #(plugin "lewis6991/spellsitter.nvim") # spellchecker for comments
      # (plugin "LnL7/vim-nix")detection
      # (plugin "junegunn/fzf")
      ];

      extraPackages = with pkgs; [
        tree-sitter
        jq curl
        nodejs
        universal-ctags

        #lsp servers
            #nix 
            rnix-lsp
            # python
            nodePackages.pyright
            # js & ts
            nodePackages.typescript nodePackages.typescript-language-server
            #rust 
            rust-analyzer

            # lua
            sumneko-lua-language-server
      ];

  };
}

