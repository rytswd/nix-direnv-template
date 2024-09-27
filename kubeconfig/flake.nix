{
  description = "Setup using Nix Direnv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
        system = system;
        # NOTE: For any vendor solutions that are considered not free (such
        # as Terraform, SurrealDB, etc.), uncomment the below line.
        # config.allowUnfree = true;
      }; in {

        ###========================================
        ##   Direnv Configuration
        #==========================================

        # Below is the actual configuration related to direnv.

        devShell = pkgs.mkShell {
          # In the below list, add any extra tools required. They will be
          # available for PATH but only within this directory and below.
          # You can find the available packages from https://search.nixos.org.
          #
          # Also, from CLI, `nh search PACKAGE` is a quick way to check. (You
          # need to have `nh` installed.)
          buildInputs = [
            # pkgs.docker-compose
          ];

          # You can define custom environment variables.
          env = {
            # This assumes that the directory where `nix flake init` is run has
            # "kubeconfig.yaml". With this setup, any child directory should
            # be able to use the dedicated config.
            "KUBECONFIG" = toString ./kubeconfig.yaml;
          };

          # You can define any shell commands upon the direnv initialisation.
          # This can be used for more complex environment variable, initial
          # setup script, valiadtion, etc.
          shellHook = ''
            echo "⚠️ Your KUBECONFIG is now based on this dir:
                    $PWD"
          '';
        };
      }
    );
}
