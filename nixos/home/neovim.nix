{ config, pkgs, lib, ... }:
let 
  #installs a vim plugin from git with a given tag /branch
  PlugGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
          url = "https://github.com/${repo}.git";
          ref = ref;
      };
  };

  #always installs the latest version
  Plug = PlugGit "HEAD";
  importFile = lib.strings.fileContents;

in 
{
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

      extraConfig = builtins.concatStringsSep "\n" [
         (importFile ./vimrc)
         (importFile ./nvim/base.vim)

         # use telescope instead
         #(importFile ./nvim/fzf.vim)

         # telescope config file (keybindings)
         (importFile ./nvim/telescope.vim)

         # lua configs
         ''
            lua << EOF
            print('Hello!! ${config.home.username} Welcome!')
            ${importFile ./nvim/plugins.lua}
            ${importFile ./nvim/lsp.lua}
            EOF
         ''
      ];

      plugins = with pkgs.vimPlugins; [

        #Common dependency for other plugins
        (Plug "nvim-lua/plenary.nvim")
        (Plug "kyazdani42/nvim-web-devicons")

        #Fuzzy finder
        (Plug "nvim-telescope/telescope.nvim")
        #(Plug "kelly-lin/telescope-ag")

        (Plug "gelguy/wilder.nvim")

        #tree-sitter!
        (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-nix
            tree-sitter-lua
            tree-sitter-python
            tree-sitter-rust
            tree-sitter-c
            tree-sitter-java
            tree-sitter-javascript
            tree-sitter-dockerfile
            tree-sitter-make
            tree-sitter-markdown
            tree-sitter-json
            tree-sitter-yaml
            tree-sitter-toml
            tree-sitter-http
            tree-sitter-css
          ]
        ))

        # brackets highlighting
        (Plug "p00f/nvim-ts-rainbow") 

        # LSP
        (Plug "neovim/nvim-lspconfig")

        # Completion
        (Plug "hrsh7th/nvim-cmp")
        (Plug "hrsh7th/cmp-nvim-lsp")
        (Plug "hrsh7th/cmp-path")

        # snippets are needed for many language servers
        (Plug "hrsh7th/cmp-vsnip")
        (Plug "hrsh7th/vim-vsnip")
        (Plug "rafamadriz/friendly-snippets") # snippet collection for all languages
        (Plug "ray-x/lsp_signature.nvim")
        (Plug "petertriho/cmp-git")

        #outlines 
        (Plug "stevearc/aerial.nvim")

        #bottom line
        (Plug "nvim-lualine/lualine.nvim")

        # colors & themes
        (Plug "akinsho/nvim-bufferline.lua")
        (Plug "Yggdroot/indentLine")
        (Plug "tomasr/molokai")
        (Plug "nanotech/jellybeans.vim")
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
      ];

  };
}

