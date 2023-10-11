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
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Do not disable this unless your GPU is unsupported or if you have a good reason to.
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
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
