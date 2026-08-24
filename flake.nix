{
  description = "Nixos config flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    systems.url = "github:nix-systems/default";

    stylix = {
      # NOTE: `stylix` branch must correspond to the current `nixpkgs` branch to
      # ensure compatibility.
      #
      # Examples:
      #
      # - github:NixOS/nixpkgs/nixos-unstable -> github:nix-community/stylix
      # - github:NixOS/nixpkgs/nixos-26.05 -> github:nix-community/stylix/release-26.05
      url = "github:nix-community/stylix/release-26.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    niri.url = "github:sodiboo/niri-flake";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
