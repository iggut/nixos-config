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
      #"vfio-pci.ids=10de:2482,10de:228b" # GPU id to bind to vfio for pass. to vm
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
    SUBSYSTEM=="kvmfr", OWNER="root", GROUP="libvirtd", MODE="0660"
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
        runAsRoot = true;
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
            "/dev/shm/looking-glass"
          ]
        '';
      };
    };
    spiceUSBRedirection.enable = true;

    # Android VM
    waydroid.enable = true;
  };

  # Link hooks to the correct directory
  system.activationScripts.libvirt-hooks.text = ''
    ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks
  '';

  # enable access from hooks to bash, modprobe, systemctl, etc
  systemd.services.libvirtd = {
    path = let
      env = pkgs.buildEnv {
        name = "qemu-hook-env";
        paths = with pkgs; [
          bash
          libvirt
          kmod
          systemd
          killall
        ];
      };
    in [env];
  };

  environment.etc = {
    "libvirt/hooks/qemu" = {
      text = ''
        #!/run/current-system/sw/bin/bash
        #
        # Author: Sebastiaan Meijer (sebastiaan@passthroughpo.st)
        #
        # Copy this file to /etc/libvirt/hooks, make sure it's called "qemu".
        # After this file is installed, restart libvirt.
        # From now on, you can easily add per-guest qemu hooks.
        # Add your hooks in /etc/libvirt/hooks/qemu.d/vm_name/hook_name/state_name.
        # For a list of available hooks, please refer to https://www.libvirt.org/hooks.html
        #

        GUEST_NAME="$1"
        HOOK_NAME="$2"
        STATE_NAME="$3"
        MISC="''${@:4}"

        BASEDIR="$(dirname $0)"

        HOOKPATH="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"

        set -e # If a script exits with an error, we should as well.

        # check if it's a non-empty executable file
        if [ -f "$HOOKPATH" ] && [ -s "$HOOKPATH"] && [ -x "$HOOKPATH" ]; then
            eval \"$HOOKPATH\" "$@"
        elif [ -d "$HOOKPATH" ]; then
            while read file; do
                # check for null string
                if [ ! -z "$file" ]; then
                  eval \"$file\" "$@"
                fi
            done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"
        fi
      '';
      mode = "0755";
    };

    "libvirt/hooks/kvm.conf" = {
      text = ''
        VIRSH_GPU_VIDEO=pci_0000_06_00_0
        VIRSH_GPU_AUDIO=pci_0000_06_00_1
        VIRSH_NVME_SSD=pci_0000_03_00_0
      '';
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/Windows-11/prepare/begin/start.sh" = {
      text = ''
        #!/run/current-system/sw/bin/bash

        # Debugging
        exec 19>/home/owner/Desktop/startlogfile
        BASH_XTRACEFD=19
        set -x

        echo "Beginning of startup"

        ## Load vfio
        modprobe vfio
        modprobe vfio_iommu_type1
        modprobe vfio_pci

        # Detach GPU devices from host
        # Use your GPU and HDMI Audio PCI host device
        virsh nodedev-detach $VIRSH_GPU_VIDEO
        virsh nodedev-detach $VIRSH_GPU_AUDIO
        # Detach SSD device from host
        virsh nodedev-detach $VIRSH_NVME_SSD

        echo "End of startup"
      '';
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/Windows-11/release/end/stop.sh" = {
      text = ''
        #!/run/current-system/sw/bin/bash

        # Debugging
        exec 19>/home/owner/Desktop/stoplogfile
        BASH_XTRACEFD=19
        set -x

        echo "Beginning of teardown"

        # Attach GPU devices to host
        # Use your GPU and HDMI Audio PCI host device
        virsh nodedev-reattach $VIRSH_GPU_VIDEO
        virsh nodedev-reattach $VIRSH_GPU_AUDIO
        # Attach SSD devices from host
        virsh nodedev-reattach $VIRSH_NVME_SSD

        ## Unload vfio
        modprobe -r vfio_pci
        modprobe -r vfio_iommu_type1
        modprobe -r vfio

        echo "End of teardown"
      '';
      mode = "0755";
    };
  };

  fonts.packages = [pkgs.dejavu_fonts]; # Need for looking-glass
}
