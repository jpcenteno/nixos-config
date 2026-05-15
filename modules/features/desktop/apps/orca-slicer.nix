{
  flake.modules.homeManager.orca-slicer =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ orca-slicer ];
    };
}
