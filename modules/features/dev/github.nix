{
  flake.modules.homeManager.github = { lib, pkgs, ... }: {
    programs.gh = {
      enable = lib.mkForce true;
      extensions = with pkgs; [
        gh-poi # Clean up branches merged at GitHub.
        gh-dash # TUI dashboard for GitHub.
      ];
    };

    # Redirect HTTPS connections to SSH.
    programs.git.extraConfig.url = {
      "ssh://git@github.com/" = {
        insteadOf = "https://github.com/";
      };
    };
  };
}
