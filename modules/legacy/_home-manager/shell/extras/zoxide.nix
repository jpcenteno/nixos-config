{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.shell.extras.zoxide;
in
{
  options.jpcenteno-home.shell.extras.zoxide = {
    enable = lib.mkEnableOption "Zoxide";

    useCdCommand = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
      description = ''
        Wether to change the prefix of the `z` and `zi` commands to `cd`.

        Doesn't work on Nushell / POSIX shells according to `man 1 zoxide-init`.
      '';
    };

    excludeDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "$HOME" ];
      example = [
        "$HOME"
        "$HOME/private/*"
      ];
      description = ''
        Prevents the specified directories from being added to the database.
        This is provided as a list of glob patterns.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    # Some options are set using environment variables. Please, refer to the
    # `ENVIRONMENT VARIABLES` section of the `zoxide (1)` manpage.
    #
    # NOTE: Why not just use `home.sessionVariables`?
    #
    # The `sessionVariables` option is designed for ENV vars that need to remain
    # constant and globally-accessible through the lifetime of a user session.
    # The downside of this is that the user must log out for changes to take
    # effect.
    #
    # The Zoxide home-manager module definition uses the following config with
    # an order value of `2000`.
    #
    # NOTE: Why use `programs.bash.initExtra`?
    #
    # Home-Manager (version 25.05) uses
    # The Zoxide-Bash integration is done
    programs.bash.initExtra =
      let
        _ZO_EXCLUDE_DIRS = lib.strings.concatStringsSep ":" cfg.excludeDirectories;
      in
      lib.mkIf config.programs.zoxide.enableBashIntegration (
        lib.mkOrder 1900 ''
          # Zoxide configuration. See `man 1 zoxide` for relevant documentation.
          export _ZO_EXCLUDE_DIRS='${_ZO_EXCLUDE_DIRS}'
        ''
      );

    programs.zoxide =
      let
        cmdOption = lib.optionals cfg.useCdCommand [
          "--cmd"
          "cd"
        ];
      in
      {
        enable = true;
        options = cmdOption;
      };
  };
}
