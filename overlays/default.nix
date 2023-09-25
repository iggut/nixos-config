{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = _final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    traefik-3 = prev.callPackage "${prev.path}/pkgs/servers/traefik" {
      buildGoModule = args:
        prev.buildGoModule (args
          // rec {
            version = "3.0.0-beta3";
            src = prev.fetchzip {
              url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
              sha256 = "sha256-1YAZs1eMAhea+Mb8NlGe8PQnrJa6ltxdY6ZTx74YP6I=";
              stripRoot = false;
            };
            vendorHash = "sha256-6Au597l0Jl2ZMGOprUwtXwMLHv50r+G+4os0ECJip6A=";
          });
    };
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  fonts = _final: prev: {
    sf-pro-fonts = prev.stdenvNoCC.mkDerivation rec {
      pname = "sf-pro-fonts";
      version = "dev";
      src = inputs.sf-pro-fonts-src;
      dontConfigure = true;
      installPhase = ''
        mkdir -p $out/share/fonts/opentype
        cp -R $src/*.otf $out/share/fonts/opentype/
      '';
    };
  };
}
