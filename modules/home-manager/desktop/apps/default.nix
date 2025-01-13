self: { config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps;
in {
  imports = [
    ./zathura.nix
    ./../../alacritty.nix
    ./chromium.nix
    ./imv.nix
    (import ./zen-browser.nix self)

    # FIXME 2024-12-07 Uncomment once I fix the issue with the activation script
    # that sets the flatpack remotes.
    # ./../common/flatpak.nix
  ];

  options.jpcenteno-home.desktop.apps = {
    enable = lib.mkEnableOption "My Desktop applications";
    mpv.enable = lib.mkEnableOption "Mpv Video Player" // { default = true; };
  };


  config = lib.mkIf cfg.enable {
    # Enables all the desktop applications allowing the user to opt-out.
    jpcenteno-home.alacritty.enable = lib.mkDefault true;
    jpcenteno-home.desktop.apps.zathura.enable = lib.mkDefault true;
    jpcenteno-home.desktop.apps.chromium.enable = lib.mkDefault true;
    jpcenteno-home.desktop.apps.chromium.setAsDefaultBrowser = lib.mkDefault true;
    jpcenteno-home.desktop.apps.imv.enable = lib.mkDefault true;
    jpcenteno-home.desktop.apps.zen-browser.enable = lib.mkDefault true;

    home.packages = [
      (lib.mkIf cfg.mpv.enable pkgs.mpv)
    ];

    # FIXME 2024-12-07 Uncomment once I fix the issue with the activation script
    # that sets the flatpack remotes.
    # jpcenteno-home.desktop.common.flatpak.enable = lib.mkDefault true;
  };
}
