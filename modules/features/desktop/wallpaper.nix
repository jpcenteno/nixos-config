{
  flake.modules.homeManager.wallpaper =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      systemd.user.services.swaybg = {
        Unit = {
          Description = "Set wallpaper with swaybg";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} -i ${config.xdg.configHome}/wallpapers/wallpaper";
          Restart = "on-failure";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
