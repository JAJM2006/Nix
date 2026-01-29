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
    cliphist
    wl-clipboard
    bibata-cursors
    pavucontrol  # Volume control GUI
    networkmanager_dmenu  # Network manager GUI
    papirus-icon-theme  # Icons for rofi
    swww 
    nnn  # Minimal terminal file manager
    yazi  # Modern terminal file manager with image preview
    satty
    wf-recorder
    fuzzel
    zoxide
    lazygit
    file-roller
    udiskie
  ];

  # Config file symlinks
  home.file.".config/niri".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Settings/config/niri";
  home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Settings/config/waybar";
  home.file.".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Settings/config/dunst";
  home.file.".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Settings/config/rofi";
  home.file.".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Settings/config/alacritty";
  home.file.".config/starship".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Settings/config/starship";

  programs.starship = {
  enable = true;
  enableZshIntegration = true;
  };

  programs.btop.enable = true;
  programs.fzf.enable = true;
  
  programs.firefox = {
  enable = true;
  profiles.juso = {
    id = 0;
    name = "juso";
    isDefault = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      # tokyo-night theme extensions
    ];
  };
};

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
    userName = "Geordie Mac";
    userEmail = "Git@JAJM2006.uk";
  };

  # GTK
  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-BL";
      package = pkgs.tokyonight-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };


programs = {
  zoxide.enable = true;
  zoxide.enableZshIntegration = true;
  
  eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };
  
  bat = {
    enable = true;
    config.theme = "TwoDark";
  };
};

}

