{
  description = "Pygame ce overlay";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = { self, nixpkgs , flake-utils, ...}@inputs: 
  let
    outputs = flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
  in rec {
    # Packages that append the python version to the previous iteration, so python312-2.5.0 for tag 2.5.0
    # - default - python312 with latest package
    packages = import ./default.nix {inherit system pkgs;};
    devShells.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        curl
        jq
        nurl
        packages.default
      ];
    };
    devShell = self.devShells.${system}.default;
    });
  in
    outputs;
}
