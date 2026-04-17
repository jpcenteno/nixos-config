{ self, ... }: {
  flake.modules.homeManager.idle-manager = { config, lib, pkgs, ... }: {
    imports = [
      self.modules.homeManager.screen-locker
    ];

    config.services.hypridle = {
      enable = true;

      settings = {
        general = {
          # Hypridle will listen for "lock session" events (like those issued by
          # `loginctl lock-session`) and execute the `lock_cmd` command.
          lock_cmd = lib.escapeShellArgs config.screen-locker.shellArgs;
        };

        listener = [];
      };
    };
  };
}
