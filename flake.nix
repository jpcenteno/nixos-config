{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter."${system}" = pkgs.alejandra;

    checks.${system} = {
      format = pkgs.stdenv.mkDerivation {
        name = "format";
        src = ./.;
        dontBuild = true;
        doCheck = true;
        nativeBuildInputs = with pkgs; [nixfmt-rfc-style];
        checkPhase = ''
          find . -name '*.nix' | xargs nixfmt --check
        '';
        installPhase = "mkdir $out"; # Will fail otherwise.
      };

      nil = pkgs.stdenv.mkDerivation {
        name = "linter";
        src = ./.;
        dontBuild = true;
        doCheck = true;
        nativeBuildInputs = [pkgs.nil];
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
        nativeBuildInputs = [pkgs.statix];
        checkPhase = ''
          statix check .
        '';
        installPhase = "mkdir $out"; # Will fail otherwise.
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [nil];
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
