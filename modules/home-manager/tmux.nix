{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.tmux;
in
{
  options.jpcenteno-home.tmux = {
    enable = lib.mkEnableOption "Enable Tmux with my personal config";

    smug.enable = lib.mkEnableOption "Smug";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tmux
      (lib.mkIf cfg.smug.enable pkgs.smug)
    ];
    xdg.configFile."tmux/tmux.conf".source = ../../dotfiles/tmux/tmux.conf;

    # Ensure $XDG_CONFIG_HOME/smug exists.
    home.activation.create-smug-config-dir = lib.mkIf cfg.smug.enable (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG '${config.xdg.configHome}/smug'
      ''
    );
  };
}
