{
  config,
  lib,
  ...
}:
let
  cfg = config.jpcenteno-home.utils;
in
{
  options.jpcenteno-home.utils = {
    enable = lib.mkEnableOption "Utility programs and their customizations";
  };

  imports = [
    ./colors/default.nix
    ./file-compression.nix
    ./taskwarrior.nix
    ./lf.nix
    ./yazi.nix
  ];

  config = lib.mkIf cfg.enable {
    jpcenteno-home.utils = {
      colors.enable = lib.mkDefault true;
      file-compression.enable = lib.mkDefault true;
      taskwarrior.enable = lib.mkDefault true;
      lf.enable = lib.mkDefault true;
      yazi.enable = lib.mkDefault true;
    };
  };
}
