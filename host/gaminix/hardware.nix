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

    ../common/hardware/audioengine.nix
    ../common/hardware/bluetooth.nix

    ../common/services/fwupd.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  services.xserver.videoDrivers = lib.mkDefault ["nvidia"];

  hardware = {
    enableAllFirmware = true;
    nvidia = {
      powerManagement.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
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
