{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.development.github;
in {
  options.jpcenteno-home.development.github = {
    enable = lib.mkEnableOption "GitHub tools";
  };

  config = lib.mkIf cfg.enable {
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
