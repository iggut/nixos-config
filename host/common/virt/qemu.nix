{
  pkgs,
  config,
  lib,
  hostname,
  ...
}: {
  boot.extraModulePackages = with config.boot.kernelPackages; [
    kvmfr
  ];
  boot.extraModprobeConfig = ''
    options kvmfr static_size_mb=128
  '';

  users.groups.libvirtd.members = ["root" "iggut"];

  boot = {
    kernelModules = [
      #"vfio_pci"
      #"vfio_iommu_type1"
      #"vfio"
      "kvmfr"
    ];
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"

      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    kernelParams = [
      "intel_iommu=on"
      "nowatchdog"
      "nopti"
      "mitigations=off"
      "preempt=voluntary"
      "iommu.passthrough=1"
      "iommu=pt"
      #"video=efifb:off"
      #"video=vesafb:off"
      "vfio-pci.ids=10de:2482,10de:228b" # GPU id to bind to vfio for pass. to vm
      "kvm.ignore_msrs=1"
      "kvm.report_ignored_msrs=0"
    ];
  };

  # Virt-manager requires iptables to let guests have internet
  networking.nftables.enable = lib.mkForce false;

  environment.sessionVariables.LIBVIRT_DEFAULT_URI = ["qemu:///system"];
  environment.systemPackages = with pkgs; [
    distrobox # Wrapper around docker to create and start linux containers - Tool for creating and managing Linux containers using Docker
    virt-manager # Gui for QEMU/KVM Virtualisation - Graphical user interface for managing QEMU/KVM virtual machines
    libguestfs
    linuxKernel.packages.linux_6_4.kvmfr
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="iggut", GROUP="libvirtd", MODE="0660"
  '';

  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      extraConfig = ''
        user="iggut"
        unix_sock_group = "libvirtd"
        unix_sock_rw_perms = "0770"
        log_filters="1:qemu"
        log_outputs="1:file:/var/log/libvirt/libvirtd.log"
      '';
      qemu = {
        package = pkgs.qemu_kvm;
        #runAsRoot = true;
        swtpm.enable = true;
        ovmf.enable = true;
        verbatimConfig = ''
          namespaces = []
          user = "iggut"
          group = "users"
          nographics_allow_host_audio = 1

          cgroup_device_acl = [
            "/dev/nvidia-modeset",
            "/dev/nvidia-uvm",
            "/dev/nvidia-uvm-tools",
            "/dev/nvidia0",
            "/dev/nvidia1",
            "/dev/nvidia2",
            "/dev/nvidia3",
            "/dev/nvidiafb",
            "/dev/nvidiactl",
            "/dev/dri/card0",
            "/dev/null",
            "/dev/full",
            "/dev/zero",
            "/dev/random",
            "/dev/urandom",
            "/dev/ptmx",
          	"/dev/kvm",
            "/dev/kqemu",
            "/dev/rtc",
          	"/dev/hpet",
            "/dev/vfio/vfio",
            "/dev/kvmfr0",
          	"/dev/vfio/22",
          ]
        '';
      };
    };
    spiceUSBRedirection.enable = true;

    # Android VM
    waydroid.enable = true;
  };

  fonts.packages = [pkgs.dejavu_fonts]; # Need for looking-glass
}
