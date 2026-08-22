{
  flake.modules.homeManager.github =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.gh = {
        enable = lib.mkForce true;
        extensions = with pkgs; [
          gh-poi # Clean up branches merged at GitHub.
          gh-dash # TUI dashboard for GitHub.
        ];
      };

      # Redirect HTTPS connections to SSH.
      programs.git.settings.url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };
}
