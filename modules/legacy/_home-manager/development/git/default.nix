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
  options.jpcenteno-home.development.git = {
    enable = lib.mkEnableOption "Enables git with my personal config";

    git-crypt.enable = lib.mkEnableOption "git-crypt" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      let
        hasGitUserSettingAssertion = attr: {
          assertion =
            config.programs.git.settings ? user
            && config.programs.git.settings.user ? ${attr}
            && null != config.programs.git.settings.user.${attr};
          message = "Git: `programs.git.settings.user.${attr}` undefined!";
        };
      in
      [
        (hasGitUserSettingAssertion "name")
        (hasGitUserSettingAssertion "email")
      ];

    programs.git = {
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

    home.packages = [
      (lib.mkIf cfg.git-crypt.enable pkgs.git-crypt)
    ];
  };
}
