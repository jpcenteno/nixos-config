{
  flake.modules.homeManager.yazi-f3d-preview =
    { lib, pkgs, ... }:
    let
      src = pkgs.fetchFromGitHub {
        owner = "Ruudjhuu";
        repo = "f3d-preview.yazi";
        rev = "76d115d94280828a2116aab3a46e43538f291331";
        hash = "sha256-katk13VE8J/Gn7N2Ez30/Xq0ldBV3yP2kowA0qVWYEg=";
      };

      f3d-preview = pkgs.runCommand "f3d-preview.yazi" { } ''
        cp -r ${src} $out

        substituteInPlace $out/main.lua \
          --replace-fail \
            'Command("f3d")' \
            'Command("${lib.getExe pkgs.f3d}")'
      '';

      rule = {
        name = "*.{3mf,obj,pts,ply,stl,step,stp}";
        run = "f3d-preview";
      };
    in
    {
      programs.yazi = {
        plugins = { inherit f3d-preview; };

        settings.plugin = {
          prepend_previewers = [ rule ];
          prepend_preloaders = [ rule ];
        };
      };
    };
}
