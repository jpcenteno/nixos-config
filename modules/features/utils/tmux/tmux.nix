{
  flake.modules.homeManager.tmux =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.smug
      ];

      programs.tmux.enable = true;
    };
}
