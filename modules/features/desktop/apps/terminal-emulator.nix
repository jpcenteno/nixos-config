# Installs and configures a GUI terminal emulator.
#
# The module name is **intentionally generic** so I can decouple other
# configuration modules from whatever application I chose to run as my default
# terminal emulator.
{
  flake.modules.homeManager.terminal-emulator =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.terminal-emulator.command = lib.mkOption {
        description = ''
          Command to open a new terminal emulator window.
        '';
        type = lib.types.listOf lib.types.str;
        readOnly = true;
        default = [ (lib.getExe config.programs.ghostty.package) ];
        defaultText = "[ \"/nix/store/<hash>-ghostty-<version>/bin/ghostty\" ]";
      };

      config = {
        programs.ghostty = {
          enable = true;
          enableBashIntegration = true;
        };

        home.activation.reload-ghostty-config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if "${lib.getExe' pkgs.procps "pgrep"}" ghostty >/dev/null; then
            run "${lib.getExe' pkgs.procps "pkill"}" -SIGUSR2 ghostty
          fi
        '';

        stylix.fonts.sizes.terminal = 16;
      };
    };
}
