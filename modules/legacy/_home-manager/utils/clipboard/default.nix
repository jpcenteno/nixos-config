{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.utils.clipboard;

  package = pkgs.stdenv.mkDerivation {
    name = "copypasta";
    version = "0.0.1";
    src = ./.;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src/copy.sh $out/bin/copy
      cp $src/pasta.sh $out/bin/pasta
      chmod +x $out/bin/*
    '';
  };

in
{
  options.jpcenteno-home.utils.clipboard = {
    enable = lib.mkEnableOption "clipboard utils and config";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ package ];
  };
}
