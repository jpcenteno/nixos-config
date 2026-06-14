{
  perSystem =
    { pkgs, ... }:
    {
      devShell = {
        packages = [ pkgs.flake-checker ];

        shellHook = ''
          export FLAKE_CHECKER_NO_TELEMETRY=true
        '';
      };
    };
}
