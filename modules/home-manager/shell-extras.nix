{ config, pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.jq
    pkgs.ripgrep
    pkgs.shellcheck
  ];

  programs.starship = {
    enable = true;
    # This requires `programs.bash.enable` to be set to `true`.
    enableBashIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = { theme = "base16"; };
  };

  programs.bash = {
    # FIXME does this belong here?
    # This is required by `program.starship.enableBashIntegration`, but also
    # required more generally to inherit `home.sessionVariables`, so it might
    # belong in `home.nix` or it's own module.
    enable = true;
    shellAliases = {
      # Standard programs replacements.
      cat = "bat";
      ls = "eza";
    };
  };
}
