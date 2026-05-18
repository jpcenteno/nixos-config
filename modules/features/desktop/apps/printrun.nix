{
  flake.modules.homeManager.printrun =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ printrun ];
    };
}
