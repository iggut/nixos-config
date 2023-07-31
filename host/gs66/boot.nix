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
        "rtsx_pci_sdmmc"
        "thunderbolt"
      ];
      kernelModules = [];
    };

    blacklistedKernelModules = ["nouveau"];

    supportedFilesystems = ["btrfs" "ntfs"];

    binfmt.emulatedSystems = ["aarch64-linux"];

    kernelModules = [
      "kvm_intel"
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "vhost_vsock"
    ];

    # Use the latest Linux kernel, rather than the default LTS
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
