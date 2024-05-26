{ config, lib, pkgs, ... }:
let cfg = config.self.libreoffice;
in {
  options.self.libreoffice = { enable = lib.mkEnableOption "libreoffice"; };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable { home.packages = [ pkgs.libreoffice ]; })

    (lib.mkIf (!cfg.enable) {
      # Infuriatingly, LibreOffice uses `$XDG_CONFIG_DIR` to store caches. This
      # ensures that it's configuration directory gets deleted when disabled to
      # prevent oblivious storage of personal data.
      home.activation.cleanup-libreoffice-dotfiles =
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          $DRY_RUN_CMD rm $VERBOSE_ARG -rf "${config.xdg.configHome}/libreoffice"
        '';
    })
  ];
}
