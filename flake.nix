{
  description = "Setup using Nix Direnv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { system = system; }; in {
        # placeholder
      }
    ) // {
      templates.default = {
        path = ./standard-setup;
        description = "Standard template for Nix Direnv setup.";
      };
      templates.kubeconfig = {
        path = ./kubeconfig;
        description = "Template for using dedicated KUBECONFIG based on Nix Direnv setup.";
      };
    };
}
