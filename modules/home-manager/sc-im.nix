{ config, lib, pkgs-unstable, ... }:
let cfg = config.self.sc-im;
in {
  options.self.sc-im = {
    enable = lib.mkEnableOption "SC-IM, a spreadsheet program for the terminal";
  };

  config = lib.mkIf cfg.enable {

    # FIXME Update the system to NixOs 24.05, then switch to stable packages.
    #
    # SC-IM has an optional dependency on `libxls`, which is marked as insecure.
    # Neither I care for this feature.
    #
    # Im still on v23.11, but starting from 24.05, `sc-im` Xlsx support was made
    # optional and disabled by default.
    home.packages = [ pkgs-unstable.sc-im ];

  };
}
