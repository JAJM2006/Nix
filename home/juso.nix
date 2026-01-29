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
    alacritty
    rofi
    waybar
    dunst
    grim
    slurp
    brightnessctl
    playerctl
    nerd-fonts.fira-code
    niri
    greetd
  ];

  home.file.".config/niri".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Settings/config/niri";
  home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Settings/config/waybar";
  home.file.".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Settings/config/dunst";
  home.file.".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Settings/config/rofi";

  programs.btop.enable = true;
  programs.fzf.enable = true;
  
  programs.zsh = {
    enable = true;
    initContent = ''
      export PATH=$HOME/Settings/scripts:$PATH
      export EDITOR=nvim
      export VISUAL=nvim
      export XDG_RUNTIME_DIR="/run/user/$(id -u)"
      export WAYLAND_DISPLAY=wayland-1
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
