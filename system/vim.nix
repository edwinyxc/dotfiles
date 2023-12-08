{ pkgs, ... } :

{
  environment.variables = {EDITOR = "vim";};

  environment.systemPackages = with pkgs; [ 
    (vim_configurable.customize {
        name = "vi";
        vimrcConfig.packages.myPlugins = with pkgs.vimPlugins; {
            start = [ vim-nix ];
            opt = [];
        };
        vimrcConfig.customRC = (builtins.readFile ./vimrc);
    })

    wl-clipboard
  ];

}
