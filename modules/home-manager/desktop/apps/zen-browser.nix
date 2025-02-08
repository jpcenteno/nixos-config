{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.jpcenteno-home.desktop.apps.zen-browser;
in {
  options.jpcenteno-home.desktop.apps.zen-browser = {
    enable = lib.mkEnableOption "Zen Browser";
    # As of v24.05, Zen Browser is not a part of `nixpkgs`. This flake delegates
    # the responsibility of providing the right package to the module's user.
    package = lib.mkPackageOption pkgs "zen" {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
