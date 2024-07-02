{
  description = "Pygame ce overlay";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    }
  };
  outputs = { self, nixpkgs , flake-utils, ...}@inputs: 
  let
    system = "x86_64-linux";
    systems = [system];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    #pkgs = import nixpkgs {inherit system;};
    pygamece = import ./default.nix {inherit system pkgs;};
  in rec {
    # Packages that append the python version to the previous iteration, so python312-2.5.0 for tag 2.5.0
    # - default - python312 with latest package
    packages = import ./default.nix {inherit system pkgs;};
    devShells.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        curl
        jq
        nurl
      ];
    };
    devShell = self.devShells.${system}.default;
    });
  in
    outputs;
}
