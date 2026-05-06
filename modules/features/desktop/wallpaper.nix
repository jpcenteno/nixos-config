{
  flake.modules.homeManager.wallpaper =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      wallpapersConfigHome = "${config.xdg.configHome}/wallpapers";
    in
    {
      systemd.user.services.swaybg = {
        Unit = {
          Description = "Set wallpaper with swaybg";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpapersConfigHome}/wallpaper";
          Restart = "on-failure";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };

      home.activation = {
        createWallpapersConfigHome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          $DRY_RUN_CMD mkdir -p ${wallpapersConfigHome}
        '';
      };
    };
}
