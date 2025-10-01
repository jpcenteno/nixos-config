{
  config,
  lib,
  ...
}:
let
  cfg = config.jpcenteno-home.shell.extras.starship;
in
{
  options.jpcenteno-home.shell.extras.starship = {
    enable = lib.mkEnableOption "Starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;

      # Shell integrations.
      enableBashIntegration = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;

      settings = {
        # Disable version info.
        bun.disabled = lib.mkDefault true;
        conda.disabled = lib.mkDefault true;
        lua.disabled = lib.mkDefault true;
        nodejs.disabled = lib.mkDefault true;
        package.disabled = lib.mkDefault true; # Current package version number.
        rust.disabled = lib.mkDefault true;

        nix_shell = {
          symbol = "  "; # Avoid colorized emoji.
          format = "via [$symbol$state]($style) ";
          style = "fg:4"; # Base0D. Usually blue, the color of the Nix logo.
        };
      };
    };
  };
}
