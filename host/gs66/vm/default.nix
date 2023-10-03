# based on https://github.com/cole-h/nixos-config/blob/nixos/hosts/scadrial/modules/libvirt/default.nix
{
  config,
  pkgs,
  secrets,
  ...
}: let
  # https://github.com/PassthroughPOST/VFIO-Tools/blob/0bdc0aa462c0acd8db344c44e8692ad3a281449a/libvirt_hooks/qemu
  qemuHook = pkgs.writeShellScript "qemu" ''
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

    # set -e # If a script exits with an error, we should as well.

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
in {
  config = {
    users.users.shadaj.extraGroups = ["libvirtd" "kvm"];

    boot.kernelModules = ["kvm-intel" "vfio-pci"];
    boot.extraModprobeConfig = "options kvm_intel nested=1";

    boot.kernelParams = [
      "iommu=pt"
      "kvm.ignore_msrs=1"
      "kvm.report_ignored_msrs=0"
    ];

    virtualisation.libvirtd = {
      enable = true;

      qemu.ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          })
          .fd
        ];
      };

      onBoot = "ignore";
      onShutdown = "shutdown";
      extraConfig = "log_filters=\"3:remote 4:event 3:util.json 3:rpc 1:*\"\nlog_outputs=\"1:file:/var/log/libvirt/libvirtd.log\"";
    };

    environment.systemPackages = with pkgs; [
      virtmanager
    ];

    systemd.services.libvirtd = {
      # scripts use binaries from these packages
      # NOTE: All these hooks are run with root privileges... Be careful!
      path = with pkgs; [libvirt procps utillinux kmod swtpm];
      preStart = ''
        mkdir -p /var/lib/libvirt/vbios
        ln -sf ${(import ./patched-vbios.nix {inherit pkgs secrets;})}/patched.rom /var/lib/libvirt/vbios/patched-bios.rom

        mkdir -p /var/lib/libvirt/qemu
        ln -sf ${./win11.xml} /var/lib/libvirt/qemu/win11.xml

        mkdir -p /var/lib/libvirt/hooks
        mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin
        mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/release/end
        mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/started/begin

        ln -sf ${qemuHook} /var/lib/libvirt/hooks/qemu
        ln -sf ${./start.sh} /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/start.sh
        ln -sf ${./revert.sh} /var/lib/libvirt/hooks/qemu.d/win11/release/end/revert.sh
      '';
    };
  };
}
