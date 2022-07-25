{ pkgs, ... } :

{
  environment.variables = {EDITOR = "vim";};

  environment.systemPackages = with pkgs; [ (
    neovim.override {
      viAlias = true;
      vimAlias = true;
      configure = {
      	customRC = (builtins.readFile ./vimrc);
      };
    }
  )];
}
