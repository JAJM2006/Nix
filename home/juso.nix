{ config, pkgs, ... }:

{
  home.username = "juso";
  home.homeDirectory = "/home/juso";
  home.stateVersion = "25.11";

  # User packages
  home.packages = with pkgs; [
    tree
    cmus
    htop
    neofetch
    neovim
    ripgrep
    fd
    bat
    tmux
    direnv
    eza
    starship
  ];

  programs.btop.enable = true;
  programs.fzf.enable = true;
  
  programs.zsh = {
    enable = true;
    initContent = ''
      export PATH=$HOME/Settings/scripts:$PATH
      export EDITOR=nvim
      export VISUAL=nvim
    '';
  };
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Geordie Mac";
        email = "Git@JAJM2006.uk";
      };
    };
  };
}
