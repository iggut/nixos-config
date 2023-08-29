{
  pkgs,
  runner,
  lib,
  ...
}: {
  environment = {
    variables.NIXOS_OZONE_WL = "1";
    variables.XDG_SESSION_TYPE = "wayland";
    variables.XDG_SESSION_DESKTOP = "Hyprland";
    variables.XDG_CURRENT_DESKTOP = "Hyprland";
    variables.WLR_NO_HARDWARE_CURSORS = "1";

    systemPackages = with pkgs; [
      polkit_gnome
      gnome.nautilus
      gnome.zenity
    ];
  };

  services = {
    dbus = {
      enable = true;
      # Make the gnome keyring work properly
      packages = [pkgs.gnome3.gnome-keyring pkgs.gcr];
    };

    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
    };

    xserver = {
      enable = true; # Enable the X11 windowing system
      displayManager = {
        gdm = {
          enable = true;
          #wayland = false;
        };
      };
    };

    gvfs.enable = true;
  };

  security = {
    pam = {
      services = {
        # allow wayland lockers to unlock the screen
        swaylock.text = "auth include login";
        # unlock gnome keyring automatically with greetd
        gdm.enableGnomeKeyring = true;
      };
    };
  };
}
