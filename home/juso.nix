{ config, pkgs, ... }:

{
  home.username = "juso";
  home.homeDirectory = "/home/juso";
  home.stateVersion = "25.11";

  programs.git.enable = true;
  programs.git.userName = "Georide Mac";
  programs.git.userEmail = "Git@JAJM2006.uk";

  programs.zsh.enable = true;

  home.packages = with pkgs; [
    neovim
    htop
    ripgrep
    fd
    bat
  ];

  # Example app config symlink
  # home.file.".config/niri".source = ../config/niri;
}

