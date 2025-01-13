{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.development.github;
in {
  options.jpcenteno-home.development.github = {
    enable = lib.mkEnableOption "GitHub tools";
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = lib.mkForce true;
      extensions = with pkgs; [
        gh-poi # Clean up branches merged at GitHub.
        gh-dash # TUI dashboard for GitHub.
      ];
    };
  };
}
