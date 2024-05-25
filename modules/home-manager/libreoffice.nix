{ config, lib, pkgs, ... }:
let cfg = config.self.libreoffice;
in {
  options.self.libreoffice = { enable = lib.mkEnableOption "libreoffice"; };

  config = {
    # When enabled:
    home.packages = lib.mkIf cfg.enable [ pkgs.libreoffice ];

    # When disabled:
    home.activation = lib.mkIf (cfg.enable == false) {
      # Infuriatingly, LibreOffice uses `$XDG_CONFIG_DIR` to store caches. This
      # ensures that it's configuration directory gets deleted when disabled to
      # prevent oblivious storage of personal data.
      cleanup-libreoffice-dotfiles =
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          $DRY_RUN_CMD rm $VERBOSE_ARG -rf "${config.xdg.configHome}/libreoffice"
        '';
    };
  };
}
