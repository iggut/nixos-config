{
  hostname,
  pkgs,
  lib,
  username,
  ...
}: let
  # Break these packages out so they can be imported elsewhere as a common set
  # of baseline packages. Useful for installations that are home-manager-only
  # on other OSs, rather than NixOS.
  inherit ((import ./packages.nix {inherit pkgs;})) basePackages;
in {
  imports = [
    ./boot.nix
    ./console.nix
    ./locale.nix

    ../services/avahi.nix
    ../services/firewall.nix
    ../services/networkmanager.nix
    ../services/openssh.nix
    ../services/swapfile.nix
    ../services/tailscale.nix
  ];

  networking = {
    hostName = hostname;
    useDHCP = lib.mkDefault true;
  };

  environment.systemPackages = basePackages;

  programs = {
    nix-index-database.comma.enable = true;
    #nix-index.enableZshIntegration = true;
    command-not-found.enable = false;
    adb.enable = true;
    nm-applet.enable = true; # Network manager tray icon
    kdeconnect.enable = true; # Connect phone to PC
    zsh.enable = true;
    _1password.enable = true;
  };

  services = {
    printing.enable = true;
    printing.drivers = [
      pkgs.gutenprint
      pkgs.gutenprintBin
    ];
    flatpak.enable = true;
    chrony.enable = true;
    journald.extraConfig = "SystemMaxUse=250M";
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services.udev.extraRules = ''
    # DFU (Internal bootloader for STM32 and AT32 MCUs)
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", MODE="0664", GROUP="plugdev"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0664", GROUP="plugdev"
  '';

  # Create dirs for home-manager
  systemd.tmpfiles.rules = [
    "d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root"
  ];
}
