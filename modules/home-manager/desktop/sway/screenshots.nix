{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.self.desktop.sway.screenshots;
in {
  options.self.desktop.sway.screenshots = {
    enable = lib.mkEnableOption "Sway screenshots";
  };

  config = lib.mkIf cfg.enable {
    # See https://ertt.ca/nix/shell-scripts/ for reference.
    home.packages = let
      name = "take-screenshot";
      src = builtins.readFile ../../../../dotfiles/sway/take-screenshot;
      buildInputs = with pkgs; [bemenu grim jq libnotify slurp sway];
      script = (pkgs.writeScriptBin name src).overrideAttrs (old: {
        buildCommand = ''
          ${old.buildCommand}
          patchShebangs $out'';
      });
      take-screenshot-package = pkgs.symlinkJoin {
        inherit name;
        paths = [script] ++ buildInputs;
        buildInputs = [pkgs.makeWrapper];
        postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
      };
    in [take-screenshot-package];
  };
}
