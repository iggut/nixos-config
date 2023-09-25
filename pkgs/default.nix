{
  pkgs ? (import ../nixpkgs.nix) {},
  lib,
  ...
}: {
  qemu_7 = callPackage ./qemu_7.nix {
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
  };
}
