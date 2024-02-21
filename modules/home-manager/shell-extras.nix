{ config, pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.bat
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.jq
    pkgs.ripgrep
  ];

  programs.starship = {
    enable = true;
    # This requires `programs.bash.enable` to be set to `true`.
    enableBashIntegration = true;
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
