{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    unstable.yubikey-manager
  ];

  services = {
    pcscd.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
  };
}
