{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.jpcenteno-home.development.github;
in {
  options.jpcenteno-home.development.github = {
    enable = lib.mkEnableOption "GitHub tools";

    preferSSH =
      lib.mkEnableOption "Redirect HTTPS connections to SSH"
      // {
        default = true;
      };
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = lib.mkForce true;
      extensions = with pkgs; [
        gh-poi # Clean up branches merged at GitHub.
        gh-dash # TUI dashboard for GitHub.
      ];
    };

    # Redirect HTTPS connections to SSH.
    programs.git.extraConfig.url = lib.mkIf cfg.preferSSH {
      "ssh://git@github.com/" = {
        insteadOf = "https://github.com/";
      };
    };
  };
}
