{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.jpcenteno-home.desktop.apps;
in {
  imports = [
    ./zathura.nix
    ./../../alacritty.nix
    ./chromium.nix
    ./imv.nix
    ./keepasxc.nix
    ./zen-browser.nix

    # FIXME 2024-12-07 Uncomment once I fix the issue with the activation script
    # that sets the flatpack remotes.
    # ./../common/flatpak.nix
  ];

  options.jpcenteno-home.desktop.apps = {
    enable = lib.mkEnableOption "My Desktop applications";
    mpv.enable = lib.mkEnableOption "Mpv Video Player" // {default = true;};
    gnumeric.enable = lib.mkEnableOption "Gnumeric" // {default = true;};
    libreoffice.enable = lib.mkEnableOption "Libreoffice" // {default = true;};
    freecad.enable = lib.mkEnableOption "freecad" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    jpcenteno-home = {
      # Enables all the desktop applications allowing the user to opt-out.
      alacritty.enable = lib.mkDefault true;
      desktop.apps = {
        zathura.enable = lib.mkDefault true;
        chromium.enable = lib.mkDefault true;
        chromium.setAsDefaultBrowser = lib.mkDefault true;
        imv.enable = lib.mkDefault true;
        keepassxc.enable = lib.mkDefault true;
        zen-browser.enable = lib.mkDefault true;
      };
    };

    home.packages = [
      (lib.mkIf cfg.mpv.enable pkgs.mpv)
      (lib.mkIf cfg.gnumeric.enable pkgs.gnumeric)
      (lib.mkIf cfg.libreoffice.enable pkgs.libreoffice)
      (lib.mkIf cfg.freecad.enable pkgs.freecad-wayland)
    ];

    # FIXME 2024-12-07 Uncomment once I fix the issue with the activation script
    # that sets the flatpack remotes.
    # jpcenteno-home.desktop.common.flatpak.enable = lib.mkDefault true;
  };
}
