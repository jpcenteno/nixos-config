{
  flake.modules.homeManager.desktop-notifications = { lib, pkgs, ... }: {
    services.mako = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      settings = {
        default-timeout = 8000; # (ms)
      };
    };
  };
}
