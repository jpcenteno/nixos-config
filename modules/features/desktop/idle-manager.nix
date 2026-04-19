{ self, ... }:
let
  dim-screen-timeout = 55;
  lock-screen-timeout = dim-screen-timeout + 5;
  screen-off-timeout = lock-screen-timeout + 20;
in
{
  flake.modules.homeManager.idle-manager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      lock-session-command = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
    in
    {
      imports = [
        # self.modules.homeManager.dpms # FIXME Why didn't it fail after I commented this?
        self.modules.homeManager.screen-locker
      ];

      config.services.hypridle = {
        enable = true;

        settings = {
          general = {
            # Hypridle will listen for "lock session" events (like those issued by
            # `loginctl lock-session`) and execute the `lock_cmd` command.
            lock_cmd = lib.escapeShellArgs config.screen-locker.shellArgs;

            before_sleep_cmd = lock-session-command;
          };

          listener = [
            {
              timeout = dim-screen-timeout;
              # FIXME decouple whatever implementation is used to control the
              # brightness from this module.
              on-timeout = "${lib.getExe pkgs.brightnessctl} --save set 10%";
              on-resume = "${lib.getExe pkgs.brightnessctl} --restore";
            }

            {
              timeout = lock-screen-timeout;
              on-timeout = "${lock-session-command}";
            }

            {
              timeout = screen-off-timeout;
              on-timeout = lib.escapeShellArgs config.dpms.powerOffAllMonitorsShellArgs;
              on-resume = lib.escapeShellArgs config.dpms.powerOnAllMonitorsShellArgs;
            }
          ];
        };
      };
    };
}
