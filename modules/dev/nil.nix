{
  perSystem =
    { pkgs, ... }:
    {
      devShell.packages = [ pkgs.nil ];
    };
}
