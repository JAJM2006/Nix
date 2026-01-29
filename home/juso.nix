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
    # git moved to programs.git below
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
  programs.zsh.enable = true;  # Removed the bad line
  
  programs.git = {
    enable = true;
    userName = "Geordie Mac";
    userEmail = "Git@JAJM2006.uk";
  };
}
