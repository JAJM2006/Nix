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
    # etc...
  ];

  programs.btop.enable = true;
  programs.fzf.enable = true;
  # These often come with additional config options

  programs.git.enable = true;
  programs.git.userName = "Geordie Mac";
  programs.git.userEmail = "Git@JAJM2006.uk";
}
