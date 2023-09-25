# Custom packages, that can be defined similarly to ones from nixpkgs
# Build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{pkgs ? (import ../nixpkgs.nix) {}}: {
  ght = pkgs.callPackage ./ght {};
  qemu_7 = pkgs.callPackage ./qemu_7.nix {
    stdenv = pkgs.ccacheStdenv;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices Cocoa Hypervisor vmnet;
    inherit (pkgs.darwin.stubs) rez setfile;
    inherit (pkgs.darwin) sigtool;
  };
  qemu_7_kvm = pkgs.qemu_7.override {hostCpuOnly = true;};
  qemu_7_full = pkgs.qemu_7.override {
    smbdSupport = true;
    cephSupport = true;
    glusterfsSupport = true;
  };
  qemu_7_xen = pkgs.qemu_7.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = pkgs.xen-slim;
  };
  qemu_7_xen-light = pkgs.qemu_7.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = pkgs.xen-light;
  };
  qemu_7_xen_4_15 = pkgs.qemu_7.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = pkgs.xen_4_15-slim;
  };
  qemu_7_xen_4_15-light = pkgs.qemu_7.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = pkgs.xen_4_15-light;
  };
  qemu_7_test = pkgs.qemu_7.override {
    hostCpuOnly = true;
    nixosTestRunner = true;
  };
  # TODO: when https://gitlab.com/virtio-fs/virtiofsd/-/issues/96 is fixed remove this
  virtiofsd = pkgs.callPackage ./qemu_virtiofsd.nix {
    qemu = pkgs.qemu_7;
    stdenv = pkgs.ccacheStdenv;
  };
}
