{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps;
in {
  imports = [
    ./zathura.nix
    ./../../alacritty.nix
    ./brave.nix
    # FIXME 2024-12-07 Uncomment once I fix the issue with the activation script
    # that sets the flatpack remotes.
    # ./../common/flatpak.nix
  ];

  options.jpcenteno-home.desktop.apps = {
    enable = lib.mkEnableOption "My Desktop applications";
  };

  config = lib.mkIf cfg.enable {
    # Enables all the desktop applications allowing the user to opt-out.
    jpcenteno-home.alacritty.enable = lib.mkDefault true;
    jpcenteno-home.desktop.apps.zathura.enable = lib.mkDefault true;
    jpcenteno-home.desktop.apps.brave-browser.enable = lib.mkDefault true;
    jpcenteno-home.desktop.apps.brave-browser.setAsDefaultBrowser = lib.mkDefault true;
    # FIXME 2024-12-07 Uncomment once I fix the issue with the activation script
    # that sets the flatpack remotes.
    # jpcenteno-home.desktop.common.flatpak.enable = lib.mkDefault true;
  };
}
