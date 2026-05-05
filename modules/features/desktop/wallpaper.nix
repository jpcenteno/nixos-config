{
  flake.modules.homeManager.wallpaper =
    { lib, pkgs, ... }:
    {
      systemd.user.services.swaybg = {
        Unit = {
          Description = "Set wallpaper with swaybg";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} -i %h/images/wallpapers/wallpaper";
          Restart = "on-failure";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
