{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.hyprland;

  import-env = pkgs.writeShellScriptBin "import-env" (builtins.readFile ./hyprland/import_env.sh);
in
{
  imports = [
    ./apps/default.nix
  ];

  options.jpcenteno-home.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno-home = {
      desktop = {
        apps.enable = lib.mkDefault true;
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        exec = [
          # Update pre-existing Systemd and TMUX environment with relevant ENV
          # vars set by the desktop environment. For Tmux, this does not affect
          # pre-existing buffers.
          "${import-env}/bin/import-env tmux"
          "${import-env}/bin/import-env system"
        ];
      };
    };
  };
}
