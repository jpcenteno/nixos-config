{
  description = "Nixos config flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    systems.url = "github:nix-systems/default";

    stylix = {
      # NOTE: `stylix` branch must correspond to the current `nixpkgs` branch to
      # ensure compatibility.
      #
      # Examples:
      #
      # - github:NixOS/nixpkgs/nixos-unstable -> github:nix-community/stylix
      # - github:NixOS/nixpkgs/nixos-25.11 -> github:nix-community/stylix/release-25.11
      url = "github:nix-community/stylix/release-25.11";
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
