_: {
  perSystem =
    { pkgs, ... }:
    {

      checks = {
        nil = pkgs.stdenv.mkDerivation {
          name = "linter";
          src = ./.;
          dontBuild = true;
          doCheck = true;
          nativeBuildInputs = [ pkgs.nil ];
          checkPhase = ''
            failed=""
            find . -name "*.nix" | while read -r file; do
              echo "Linting: $file"

              diagnostics="$(nil diagnostics "$file")"
              if [ -n "$diagnostics" ]; then
                echo "$diagnostics"
                failed="yes"
              fi
            done

            test "$failed" != yes
          '';
          installPhase = "mkdir $out"; # Will fail otherwise.
        };

        statix = pkgs.stdenv.mkDerivation {
          name = "statix";
          src = ./.;
          dontBuild = true;
          doCheck = true;
          nativeBuildInputs = [ pkgs.statix ];
          checkPhase = ''
            statix check .
          '';
          installPhase = "mkdir $out"; # Will fail otherwise.
        };
      };
    };
}
