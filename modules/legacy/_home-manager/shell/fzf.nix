{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.shell.fzf;
in
{
  options.jpcenteno-home.shell.fzf = {
    enable = lib.mkEnableOption "Fzf";
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = lib.mkForce true;

      # Enable integrations with a level of "default" to allow the user to opt
      # out. Anyways, each of these depend on the module for each shell to be
      # enabled to work.
      enableBashIntegration = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;

      # Base16 colorscheme.
      #
      # Requires a new session for changes to take place as it modifies
      # `home.sessionVariables`.
      colors =
        let
          # This color mapping assumes that the terminal emulator was configured
          # with a base16 colorscheme mapped to these ANSI color codes.
          #
          # Mapping to colors 0-15 instead of directly writing the hex values
          # gives us immediate changes when the terminal emulator config changes
          # instead of having to log out and log in for `sessionVariables` changes
          # (Written to `~/.profile`) to refresh them. It also decouples this
          # module from `nix-colors` or similar libraries.
          #
          # These Base16 to ANSI color mappings were taken from my Ghostty module,
          # which in turn was taken from a base16 mustache template from somewhere
          # in the internet.
          base00 = "0";
          base0A = "3";
          base0D = "4";
          base0C = "6";
          base01 = "10";
          base04 = "12";
          base06 = "13";
        in
        {
          # This base16 color mapping for Fzf was taken from the `tinted-fzf`
          # mustache template [1].
          #
          # [1]: https://github.com/tinted-theming/tinted-fzf/blob/a5d9c44f178acf222dd2e9d7e429979706f8b9fb/templates/base16-default.mustache
          "bg" = base00;
          "bg+" = base01;
          "fg" = base04;
          "fg+" = base06;
          "header" = base0D;
          "hl" = base0D;
          "hl+" = base0D;
          "info" = base0A;
          "marker" = base0C;
          "pointer" = base0C;
          "prompt" = base0A;
          "spinner" = base0C;
        };
    };
  };
}
