{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.jpcenteno-home.tmux;
in {
  options.jpcenteno-home.tmux = {
    enable = lib.mkEnableOption "Enable Tmux with my personal config";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.tmux];
    xdg.configFile."tmux/tmux.conf".source = ../../dotfiles/tmux/tmux.conf;
  };
}
