{ pkgs, lib, config, ... }:
let
  cfg = config.jpcenteno-home.git;
in {

  imports = [
    ./development/github.nix
  ];

  options.jpcenteno-home.git = {
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

    github = {
      enable = lib.mkEnableOption "GitHub integrations" // { default = true; };
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

    xdg.configFile = {
      "git/gitignore".source = ../../dotfiles/git/gitignore;
      "git/scripts/delete-branches-interactively".source = ../../dotfiles/git/scripts/delete-branches-interactively;
    };

    # Git server tools and integrations:
    jpcenteno-home.development.github.enable = cfg.github.enable;
  };
}
