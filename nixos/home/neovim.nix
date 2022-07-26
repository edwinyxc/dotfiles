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
            EOF
         ''
      ];

      plugins = with pkgs.vimPlugins; [

        #Common dependency for other plugins
        (Plug "nvim-lua/plenary.nvim")

        #fuzzy finder
        (Plug "nvim-telescope/telescope.nvim")
        #(Plug "kelly-lin/telescope-ag")

        #tree-sitter!
        (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-lua
          ]
        ))

        # color schemes 
        (Plug "tomasr/molokai")
        (Plug "nanotech/jellybeans.vim")
        (Plug "jnurmine/Zenburn")

      # (plugin "LnL7/vim-nix")detection
      # (plugin "junegunn/fzf")
      ];

      extraPackages = with pkgs; [
        tree-sitter
        jq curl
        nodejs
        universal-ctags
      ];

  };
}

