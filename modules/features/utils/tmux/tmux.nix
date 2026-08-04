{
  flake.modules.homeManager.tmux =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.smug
      ];

      programs.tmux = {
        enable = true;
        extraConfig = ''
          set-option -g set-titles on
          set-option -g set-titles-string "#S / #W"
        '';
      };
    };
}
