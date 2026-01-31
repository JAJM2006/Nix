{ config, ... }:
{
  programs.noctalia-shell = {
    enable = true;
    settings = "${config.home.homeDirectory}/Settings/config/nixos/noctalia/settings.json";
  };
}
