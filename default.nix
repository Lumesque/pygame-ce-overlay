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
  versions = lib.lists.forEach python_vers (p: 
    let 
      # Specific python builder ex python312Packages
      package_name = p + "Packages";
    in
    { package = 
    lib.attrsets.mapAttrs' (name: value:  lib.nameValuePair (p + "-" + name) 
        (
          pkgs.${package_name}.buildPythonPackage rec {
            pname = "pygame-ce";
            version = name;
            doCheck = false;
            # use fetchgit so this happens during build time not eval time
            src = pkgs.fetchgit {
              hash = value.hash;
              url = value.url;
              rev = name;
            };
            # Manually create the build phase since pygame-ce uses diff path vars
            buildPhase = ''
            export PYGAME_EXTRA_BASE="${pkgs.portmidi}:${pkgs.SDL2_mixer}:${pkgs.SDL2}:${pkgs.openssl}:${pkgs.glib}:${pkgs.SDL2_image}:${pkgs.freetype}:${pkgs.SDL2_ttf}"
            echo "----------------------------------------------"
            python setup.py build
            python setup.py bdist_wheel
            '';
            buildInputs = [
              pkgs.freetype
              pkgs.openssl
              pkgs.dbus
              pkgs.dpkg
              pkgs.SDL2
              pkgs.portmidi
            ];
            nativeBuildInputs = [
              (pkgs.python312.withPackages (pp: [
                pp.cython
                pp.wheel
                pp.sphinx
                pp.setuptools
              ]))
              pkgs.pkg-config
              pkgs.SDL2_ttf
              pkgs.SDL2_mixer
              pkgs.SDL2_image
              pkgs.glib
            ];
          }
        )
      ) sources;
    });
  attrs = builtins.foldl' (x: y: x//y.package) {} versions;
  in
    # Set default to first tag, which is usually organized through jq groupby
    {"default"= attrs.${first_tag};} // attrs
