{
  description = "Pygame ce overlay";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs , flake-utils, ...}@inputs: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in rec {
    # Packages that append the python version to the previous iteration, so python312-2.5.0 for tag 2.5.0
    # - default - python312 with latest package
    packages.${system}.default = import ./default.nix {inherit system pkgs;};
    devShells.${system}.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        curl
        jq
        nurl
      ];
    };
    overlays.default = final: prev: {
      pygamepkgs = packages.${system};
    };
  };
}
