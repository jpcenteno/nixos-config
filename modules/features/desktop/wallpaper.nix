{
  flake.modules.homeManager.wallpaper =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      target = "graphical-session.target";
      wallpapersConfigHome = "${config.xdg.configHome}/wallpaper";
    in
    {
      systemd.user.services.swaybg = {
        Unit = {
          Description = "Set wallpaper with swaybg";
          PartOf = [ target ];
          After = [ target ];
        };

        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpapersConfigHome}/current";
          Restart = "on-failure";
        };

        Install = {
          WantedBy = [ target ];
        };
      };

      systemd.user.paths.swaybg-wallpaper-watch = {
        Unit = {
          Description = "Watch wallpaper file for changes";
          PartOf = [ target ]; # Ties lifecycle to `graphical-session`.
          After = [ target ]; # Defers start until `graphical-session` is active.
        };

        Path = {
          # NOTE: Prefer `PathChanged` over `PathModified` because it will only
          # trigger after the file is closed. Using `PathModified` can led to
          # bursts of unnecessary restarts.
          # NOTE: I'm monitoring the directory here because symlink redirection
          # didn't work when I monitored the file directly. This is intended as
          # a single file directory, so there should be no problems unless I
          # start piling more crap there.
          PathChanged = wallpapersConfigHome;
          Unit = "refresh-wallpaper.service";
        };

        Install = {
          WantedBy = [ target ];
        };
      };

      systemd.user.services.refresh-wallpaper = {
        Unit = {
          Description = "Restart swaybg when wallpaper file changes";
        };

        Service = {
          Type = "oneshot";
          ExecStart = "${lib.getExe' pkgs.systemd "systemctl"} --user restart swaybg.service";
        };
      };

      home.activation = {
        createWallpapersConfigHome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          $DRY_RUN_CMD mkdir -p ${wallpapersConfigHome}
        '';
      };
    };
}
