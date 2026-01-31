{ config, lib, ... }:
{
  programs.noctalia-shell = {
    enable = true;
    settings = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/nixos/noctalia/settings.json";
  };
}
