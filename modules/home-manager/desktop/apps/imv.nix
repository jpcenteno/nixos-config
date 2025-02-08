{
  config,
  lib,
  ...
}: let
  cfg = config.jpcenteno-home.desktop.apps.imv;
in {
  options.jpcenteno-home.desktop.apps.imv = {
    enable = lib.mkEnableOption "Imv image viewer.";
  };

  config = lib.mkIf cfg.enable {
    programs.imv.enable = lib.mkForce true;

    # Without this the browser may take precedence over Imv.
    xdg.mimeApps.defaultApplications = {
      "image/gif" = ["imv.desktop"];
      "image/png" = ["imv.desktop"];
      "image/apng" = ["imv.desktop"];
      "image/avif" = ["imv.desktop"];
      "image/jpeg" = ["imv.desktop"];
      "image/webp" = ["imv.desktop"];
      "image/svg+xml" = ["imv.desktop"];
    };
  };
}
