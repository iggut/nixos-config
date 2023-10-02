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
  fileSystems."/run/media/iggut/share" = {
    device = "/dev/disk/by-uuid/1de78f65-6097-423f-ad63-406ab9b11752";
    fsType = "btrfs";
    options = ["uid=1000" "gid=1000" "rw" "user" "exec" "umask=000"];
  };

  jovian.steam = {
    enable = true;
    #useStockEnvironment = false;
    #environment = {
    #  "INTEL_DEBUG" = "noccs";
    #};
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  services.xserver.videoDrivers = lib.mkDefault ["nvidia"];

  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_6_5.kvmfr
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
