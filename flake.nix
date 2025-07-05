{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      treefmt-nix,
      ...
    }:
    let
      # Small tool to iterate over each systems
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      checks = eachSystem (pkgs: {
        format = treefmtEval.${pkgs.system}.config.build.check self;

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
      });

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ nil ];
      };

      nixosModules = {
        default = import ./modules/nixos/default.nix;
        hello = import ./modules/nixos/hello.nix;
        keyd = import ./modules/nixos/keyd.nix;
      };

      homeManagerModules = {
        default = import ./modules/home-manager;
        hello = import ./modules/home-manager/hello.nix;
        alacritty = import ./modules/home-manager/alacritty.nix;
        brave-browser = import ./modules/home-manager/desktop/apps/brave.nix;
        desktop.fonts = import ./modules/home-manager/desktop/fonts.nix;
        desktop.apps = import ./modules/home-manager/desktop/apps;
        git = import ./modules/home-manager/git.nix;
        hyprland = import ./modules/home-manager/desktop/hyprland.nix;
        tmux = import ./modules/home-manager/tmux.nix;
      };
    };
}
