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

    ./vm
  ];

  jovian.steam = {
    enable = true;
    useStockEnvironment = false;
    environment = {
      "INTEL_DEBUG" = "noccs";
    };
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

  #fix Gamescope glitchy graphics intel/nvidia
  programs.gamescope = lib.mkDefault {
    env = lib.mkDefault {
      "INTEL_DEBUG" = "noccs";
    };
  };
  programs.steam.gamescopeSession.env = lib.mkDefault {
    "INTEL_DEBUG" = "noccs";
  };

  services = {
    auto-cpufreq.enable = true;
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
