{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.development.github;
in {
  options.jpcenteno-home.development.github = {
    enable = lib.mkEnableOption "GitHub tools";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        # Using this to ensure that Git is installed and configured. It would make
        # no sense to configure the Github CLI without Git itself.
        # jpcenteno-home.git.enable = lib.mkDefault true;
        assertion = (config.programs.git.enable == true);
        message = "GitHub tools require `programs.git` to be enabled";
      }
    ];

    # GitHub CLI and extensions.
    programs.gh = {
      enable = lib.mkforce cfg.github-cli.enable;
      extensions = with pkgs; [
        gh-poi # Safely clean up your local branches.
        gh-dash # TUI dashboard for GitHub.
      ];
    };
  };
}
