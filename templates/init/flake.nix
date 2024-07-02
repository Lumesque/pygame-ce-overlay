{
  description = "An empty project that includes pygame";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    pygamece.url = "github:Lumesque/pygame-ce-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs , flake-utils, pygamece}: 

  flake-utils.lib.eachDefaultSystem (system: 
  let
    # Adds pygame into the python312 packages
    overlays = [pygamece.overlays.default];
    pkgs = import nixpkgs {inherit system overlays;};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          python312.withPackages (pp: 
            pp.pygamece.default
          )
        ];
      };
      devShell = self.devShells.${system}.default;
    }
  );
}
