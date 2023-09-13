{
  inputs,
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    (import ./disks.nix {})
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.jovian.nixosModules.jovian

    ../common/hardware/audioengine.nix
    ../common/hardware/bluetooth.nix

    ../common/services/fwupd.nix
  ];

  # Windows game drive nvme
  fileSystems."/run/media/iggut/gamedisk" = {
    device = "/dev/disk/by-uuid/9E049FCD049FA735";
    fsType = "ntfs";
    options = ["uid=1000" "gid=1000" "nodev" "nofail" "rw" "user" "exec" "umask=000"];
  };

  jovian.steam = {
    enable = true;
    useStockEnvironment = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  services.xserver.videoDrivers = lib.mkDefault ["nvidia"];

  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_6_4.kvmfr
  ];

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    enableAllFirmware = true;
    nvidia = {
      powerManagement.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
  };

  swapDevices = [
    {
      device = "/.swap/swapfile";
      size = 2048;
    }
  ];
}
#        "https://us.download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}.run"
#        "https://download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}.run"

