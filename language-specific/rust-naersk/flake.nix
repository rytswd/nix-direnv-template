{
  description = "Setup for Nix Direnv and Rust toolchain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    naersk.url = "github:nix-community/naersk";

    crane.url = "github:ipetkov/crane";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          system = system;
          overlays = [ inputs.fenix.overlays.default ];
        };

        fenixPkgs = inputs.fenix.packages.${system}.complete;
        naersk' = pkgs.callPackage inputs.naersk { };

        # Any runtime dependencies for the target architecture.
        buildInputs = [
          # Placeholder
        ];

        # Any build time dependencies.
        nativeBuildInputs = with pkgs; [
          nixpkgs-fmt

          # Test setup
          cargo-nextest
          cargo-llvm-cov
          cargo-tarpaulin
        ];

        # NOTE: For any vendor solutions that are considered not free (such
        # as Terraform, SurrealDB, etc.), uncomment the below line.
        # config.allowUnfree = true;
      in rec {
        # NOTE: rec needed due to the recursive reference.

        ###========================================
        ##   Packaging with Nix
        #==========================================

        # TBC

        ###========================================
        ##   Direnv Configuration
        #==========================================
        devShell = pkgs.mkShell {
          nativeBuildInputs = buildInputs ++ nativeBuildInputs;
        };
      }
    );
}
