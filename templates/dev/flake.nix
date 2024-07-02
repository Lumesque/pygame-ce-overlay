{
  description = "An empty environment where you can compile pygame manually";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    # Used for shell.nix
    flake-compat = {
      url = "github:deolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ...}: 

  flake-utils.lib.eachDefaultSystem(system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        (python312.withPackages (pp: [
          pp.setuptools
          pp.cython
          pp.wheel
          pp.sphinx
        ])) 
        freetype
        openssl
        dbus
        dpkg
        SDL2
        pkg-config
        SDL2_ttf
        SDL2_mixer
        SDL2_image
      ];
    };
  }
  );
}
