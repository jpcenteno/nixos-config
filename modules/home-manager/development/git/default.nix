{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.development.git;

  pre-commit = pkgs.writeShellApplication {
    name = "jpcenteno-pre-commit-hook";
    runtimeInputs = [ pkgs.gum ];
    text = builtins.readFile ./hooks/pre-commit-hook.sh;
  };
in
{
  imports = [
    ./github.nix
  ];

  options.jpcenteno-home.development.git = {
    enable = lib.mkEnableOption "Enables git with my personal config";

    userName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "User name to use. Must be set when Git is enabled.";
    };

    userEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "User email to use. Must be set when Git is enabled.";
    };

    git-crypt.enable = lib.mkEnableOption "git-crypt" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.isString cfg.userName;
        message = "`jpcenteno-home.git.userName` must be set when Git is enabled.";
      }
      {
        assertion = builtins.isString cfg.userEmail;
        message = "`jpcenteno-home.git.userEmail` must be set when Git is enabled.";
      }
    ];

    programs.git = {
      inherit (cfg) userName userEmail;
      enable = true;
      includes = [
        { path = ./config; }
      ];

      hooks.pre-commit = lib.getExe pre-commit;
    };

    xdg.configFile = {
      "git/gitignore".source = ./gitignore;
      "git/scripts/delete-branches-interactively".source = ./scripts/delete-branches-interactively;
    };

    jpcenteno-home.development.git.github.enable = lib.mkDefault true;

    home.packages = [
      (lib.mkIf cfg.git-crypt.enable pkgs.git-crypt)
    ];
  };
}
