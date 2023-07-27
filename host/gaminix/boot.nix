{pkgs, ...}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
      kernelModules = [];
    };

    blacklistedKernelModules = ["nouveau"];

    supportedFilesystems = ["btrfs" "ntfs"];

    binfmt.emulatedSystems = ["aarch64-linux"];

    kernelModules = [
      "kvm_intel"
      "vhost_vsock"
    ];

    # Use the latest Linux kernel, rather than the default LTS
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
