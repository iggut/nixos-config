{
  pkgs,
  config,
  ...
}: {
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
      kernelModules = ["nvidia"];
    };

    kernelParams = [
      "nvidia_drm.modeset=1"
      "rd.driver.blacklist=nouveau"
      "modprobe.blacklist=nouveau"
      "module_blacklist=i915"
      "video=HDMI-A-1:2560x1440@59.951"
      #"video=DP-1:1920x1080@165"
    ];

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
    #kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
    #kernelPackages = pkgs.linuxPackages;
  };
}
