{
  flake.modules.homeManager.xdg-portals =
    { pkgs, ... }:
    {
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
        config.common = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
      };
    };
}
