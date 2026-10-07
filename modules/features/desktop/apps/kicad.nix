{
  flake.modules.homeManager.kicad = { pkgs, ... }: {
    home.packages = [ pkgs.kicad ];
  };
}
