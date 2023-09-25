{
  inputs,
  pkgs,
  lib,
  ...
}: {
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

  qemu_7 = callPackage ./qemu_7.nix {
    stdenv = pkgs.ccacheStdenv;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices Cocoa Hypervisor vmnet;
    inherit (pkgs.darwin.stubs) rez setfile;
    inherit (pkgs.darwin) sigtool;
  };
  qemu_7_kvm = lib.lowPrio (pkgs.qemu_7.override {hostCpuOnly = true;});
  qemu_7_full = lib.lowPrio (pkgs.qemu_7.override {
    smbdSupport = true;
    cephSupport = true;
    glusterfsSupport = true;
  });
  qemu_7_xen = lib.lowPrio (pkgs.qemu_7.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = pkgs.xen-slim;
  });
  qemu_7_xen-light = lib.lowPrio (pkgs.qemu_7.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = pkgs.xen-light;
  });
  qemu_7_xen_4_15 = lib.lowPrio (pkgs.qemu_7.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = pkgs.xen_4_15-slim;
  });
  qemu_7_xen_4_15-light = lib.lowPrio (pkgs.qemu_7.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = pkgs.xen_4_15-light;
  });
  qemu_7_test = lib.lowPrio (pkgs.qemu_7.override {
    hostCpuOnly = true;
    nixosTestRunner = true;
  });
  # TODO: when https://gitlab.com/virtio-fs/virtiofsd/-/issues/96 is fixed remove this
  virtiofsd = callPackage ./qemu_virtiofsd.nix {
    qemu = pkgs.qemu_7;
    stdenv = pkgs.ccacheStdenv;
  };
}
