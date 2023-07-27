{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
    (import ./disks.nix {})

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ../common/hardware/audioengine.nix
    ../common/hardware/bluetooth.nix

    ../common/services/fwupd.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  hardware = {
    enableAllFirmware = true;
  };

  swapDevices = [
    {
      device = "/.swap/swapfile";
      size = 2048;
    }
  ];
}
