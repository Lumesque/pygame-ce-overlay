{
  pkgs ? import <nixpkgs> {},
  system ? builtins.currentSystem,
  python_vers ? ["python312" "python311" "python310"]
}: let
  inherit (pkgs) lib;
  # Sources that has each ref needed to make a package
  sources = builtins.fromJSON (builtins.readFile ./index.json);
  # Sources that has branches, and tags
  _tags = builtins.fromJSON (builtins.readFile ./sources.json);
  first_tag = "python312" + "-" + lib.lists.head _tags.tag;
  versions = lib.lists.forEach python_vers (p: lib.attrsets.mapAttrs' (name: value:  lib.nameValuePair (p + "-" + name)
        (
          pkgs.python312Packages.buildPythonPackage rec {
            pname = "pygame-ce";
            version = name;
            doCheck = false;
            src = pkgs.fetchFromGitHub {
              owner = value.owner;
              repo = value.repo;
              rev = name;
              hash = value.hash;
            };
            buildInputs = [
              (pkgs.python312.withPackages (pp: [
                pp.setuptools
                pp.cython
                pp.wheel
                pp.sphinx
              ]
              ))
              pkgs.freetype
              pkgs.openssl
              pkgs.dbus
              pkgs.dpkg
              pkgs.SDL2
              pkgs.portmidi
            ];
            nativeBuildInputs = [
              pkgs.pkg-config
              pkgs.SDL2_ttf
              pkgs.SDL2_mixer
              pkgs.SDL2_image
            ];
          }
        ) 
      ) sources);
  attrs = builtins.foldl' (x: y: x//y) {} versions;
  _default = attrs.${first_tag};
  in
    #{"default"= attrs.${first_tag};} // attrs
    {"default"= _default;} // attrs


