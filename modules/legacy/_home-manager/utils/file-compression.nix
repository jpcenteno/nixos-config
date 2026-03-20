{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.utils.file-compression;
in
{
  options.jpcenteno-home.utils.file-compression = {
    enable = lib.mkEnableOption "File compression utilities";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gnutar
      gzip
      unrar
      unzip
      xz
      zip
    ];
  };
}
