{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps;
in {
  imports = [
    ./zathura.nix
    ./../../alacritty.nix
    ./../../brave.nix
    ./../common/flatpak.nix
  ];

  options.jpcenteno-home.desktop.apps = {
    enable = lib.mkEnableOption "My Desktop applications";
  };

  config = lib.mkIf cfg.enable {
    # Enables all the desktop applications allowing the user to opt-out.
    jpcenteno-home.alacritty.enable = lib.mkDefault true;
    jpcenteno-home.desktop.apps.zathura.enable = lib.mkDefault true;
    jpcenteno-home.brave-browser.enable = lib.mkDefault true;
    jpcenteno-home.brave-browser.setAsDefaultBrowser = lib.mkDefault true;
    jpcenteno-home.desktop.common.flatpak.enable = lib.mkDefault true;
  };
}
