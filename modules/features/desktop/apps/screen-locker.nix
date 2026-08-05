# Installs and configures a desktop screen locker.
#
# The module name is **intentionally generic** so I can decouple other
# configuration modules from whatever application I chose to run as my default
# screen locker.
{
  flake.modules.homeManager.screen-locker =
    { config, lib, ... }:
    {
      options.screen-locker.shellArgs = lib.mkOption {
        description = ''
          Command and argument list for locking the screen.

          If you need this as a string, use `lib.escapeShellArgs`.
        '';
        type = lib.types.listOf lib.types.str;
        readOnly = true;
        default = [ (lib.getExe config.programs.hyprlock.package) ];
        defaultText = "[ \"<program>\" \"<arg1>\" \"<arg2>\" ]";
      };

      config = {
        programs.hyprlock.enable = true;
      };
    };
}
