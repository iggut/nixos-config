{
  pkgs,
  lib,
  ...
}: {
  environment = {
    variables = {
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
    };

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

  programs = {
    hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland = {
        enable = true;
        hidpi = false;
      };
    };
  };
}
