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

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  environment.systemPackages = [config.nur.repos.ataraxiasjel.waydroid-script];

  hardware = {
    enableAllFirmware = true;
    nvidia = {
      powerManagement.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
  };

  #fix Gamescope glitchy graphics intel/nvidia
  programs.gamescope = {
    env = {
      "INTEL_DEBUG" = "noccs";
    };
  };

  services = {
    # use Ambient Light Sensors for auto brightness adjustment
    clight = {
      enable = true;
    };
    clight.settings = {
      verbose = true;
      dpms.timeouts = [900 300];
      dimmer.timeouts = [870 270];
      screen.disabled = true;
      sensor = let
        regression = [0.000 0.104 0.299 0.472 0.621 0.749 0.853 0.935 0.995 1.000 1.000];
      in {
        ac_regression_points = regression;
        bat_regression_points = regression;
      };
    };
  };
  swapDevices = [
    {
      device = "/.swap/swapfile";
      size = 2048;
    }
  ];
}
