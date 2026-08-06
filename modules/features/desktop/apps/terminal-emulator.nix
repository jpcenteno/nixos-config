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

        # Reload Ghostty config whenever it changes.
        #
        # NOTE: the `onChange` script will run multiple times if more than one
        # file changes at the same time, but this is harmless.
        xdg.configFile =
          let
            # NOTE: `mkAfter` is in place to ensure the default syntax
            # validation that Home Manager calls comes before actual evaluation.
            onChange = lib.mkAfter ''
              if "${lib.getExe' pkgs.procps "pgrep"}" ghostty >/dev/null; then
                $DRY_RUN_CMD run "${lib.getExe' pkgs.procps "pkill"}" -SIGUSR2 ghostty
              fi
            '';
            themeFiles = map (name: "ghostty/themes/${name}") (lib.attrNames config.programs.ghostty.themes);
          in
          lib.genAttrs ([ "ghostty/config" ] ++ themeFiles) (_: {
            inherit onChange;
          });

        stylix.fonts.sizes.terminal = 16;
      };
    };
}
