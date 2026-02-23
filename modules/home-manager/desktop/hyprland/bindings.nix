{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.desktop.hyprland.bindings;
in {
  options.jpcenteno-home.desktop.hyprland.bindings = {
    enable = lib.mkEnableOption ''
      Hyprland binding configuration.

      This submodule exists to prevent conflicts by providing a common
      abstraction for key maps.
    '';

    modH = lib.mkOption { default = "movefocus, l"; };
    modJ = lib.mkOption { default = "movefocus, d"; };
    modK = lib.mkOption { default = "movefocus, u"; };
    modL = lib.mkOption { default = "movefocus, r"; };

    modShiftH = lib.mkOption { default = "movewindoworgroup, l"; };
    modShiftJ = lib.mkOption { default = "movewindoworgroup, d"; };
    modShiftK = lib.mkOption { default = "movewindoworgroup, u"; };
    modShiftL = lib.mkOption { default = "movewindoworgroup, r"; };

    # Arrow key bindings default to `hjkl` mappings because Vim.
    modLeft = lib.mkOption { default = cfg.modH; };
    modDown =lib.mkOption { default = cfg.modJ; };
    modUp = lib.mkOption { default = cfg.modK; };
    modRight =lib.mkOption { default = cfg.modL; };
    modShiftLeft = lib.mkOption { default = cfg.modShiftH; };
    modShiftDown =lib.mkOption { default = cfg.modShiftJ; };
    modShiftUp = lib.mkOption { default = cfg.modShiftK; };
    modShiftRight =lib.mkOption { default = cfg.modShiftL; };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = [
      "$mod, h, ${cfg.modH}"
      "$mod, j, ${cfg.modJ}"
      "$mod, k, ${cfg.modK}"
      "$mod, l, ${cfg.modL}"

      "$mod, left, ${cfg.modLeft}"
      "$mod, down, ${cfg.modDown}"
      "$mod, up, ${cfg.modUp}"
      "$mod, right, ${cfg.modRight}"

      "$mod&SHIFT, h, ${cfg.modShiftH}"
      "$mod&SHIFT, j, ${cfg.modShiftJ}"
      "$mod&SHIFT, k, ${cfg.modShiftK}"
      "$mod&SHIFT, l, ${cfg.modShiftL}"

      "$mod&SHIFT, left, ${cfg.modShiftLeft}"
      "$mod&SHIFT, down, ${cfg.modShiftDown}"
      "$mod&SHIFT, up, ${cfg.modShiftUp}"
      "$mod&SHIFT, right, ${cfg.modShiftRight}"
    ];
  };
}
