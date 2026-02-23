{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.desktop.hyprland.bindings;

  mkBindingOption =
    { default }:
    lib.mkOption {
      inherit default;
      type = lib.types.str;
    };

  mkFunctionBindingOption =
    { default }:
    lib.mkOption {
      inherit default;
      type = lib.types.functionTo lib.types.str;
    };
in
{
  options.jpcenteno-home.desktop.hyprland.bindings = {
    enable = lib.mkEnableOption ''
      Hyprland binding configuration.

      This submodule exists to prevent conflicts by providing a common
      abstraction for key maps.
    '';

    modH = mkBindingOption { default = "movefocus, l"; };
    modJ = mkBindingOption { default = "movefocus, d"; };
    modK = mkBindingOption { default = "movefocus, u"; };
    modL = mkBindingOption { default = "movefocus, r"; };

    modShiftH = mkBindingOption { default = "movewindoworgroup, l"; };
    modShiftJ = mkBindingOption { default = "movewindoworgroup, d"; };
    modShiftK = mkBindingOption { default = "movewindoworgroup, u"; };
    modShiftL = mkBindingOption { default = "movewindoworgroup, r"; };

    # Arrow key bindings default to `hjkl` mappings because Vim.
    modLeft = mkBindingOption { default = cfg.modH; };
    modDown = mkBindingOption { default = cfg.modJ; };
    modUp = mkBindingOption { default = cfg.modK; };
    modRight = mkBindingOption { default = cfg.modL; };
    modShiftLeft = mkBindingOption { default = cfg.modShiftH; };
    modShiftDown = mkBindingOption { default = cfg.modShiftJ; };
    modShiftUp = mkBindingOption { default = cfg.modShiftK; };
    modShiftRight = mkBindingOption { default = cfg.modShiftL; };

    modShiftNumber = mkFunctionBindingOption {
      default = n: "movetoworkspace, ${toString n}";
    };
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

      "$mod SHIFT, h, ${cfg.modShiftH}"
      "$mod SHIFT, j, ${cfg.modShiftJ}"
      "$mod SHIFT, k, ${cfg.modShiftK}"
      "$mod SHIFT, l, ${cfg.modShiftL}"

      "$mod SHIFT, left, ${cfg.modShiftLeft}"
      "$mod SHIFT, down, ${cfg.modShiftDown}"
      "$mod SHIFT, up, ${cfg.modShiftUp}"
      "$mod SHIFT, right, ${cfg.modShiftRight}"

      "$mod SHIFT, 1, ${cfg.modShiftNumber 1}"
      "$mod SHIFT, 2, ${cfg.modShiftNumber 2}"
      "$mod SHIFT, 3, ${cfg.modShiftNumber 3}"
      "$mod SHIFT, 4, ${cfg.modShiftNumber 4}"
      "$mod SHIFT, 5, ${cfg.modShiftNumber 5}"
      "$mod SHIFT, 6, ${cfg.modShiftNumber 6}"
      "$mod SHIFT, 7, ${cfg.modShiftNumber 7}"
      "$mod SHIFT, 8, ${cfg.modShiftNumber 8}"
      "$mod SHIFT, 9, ${cfg.modShiftNumber 9}"
    ];
  };
}
