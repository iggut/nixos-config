{
  pkgs,
  lib,
  config,
  ...
}: {
  environment = {
    # Move ~/.Xauthority out of $HOME (setting XAUTHORITY early isn't enough)
    extraInit = ''
      export XAUTHORITY=/tmp/Xauthority
      [ -e ~/.Xauthority ] && mv -f ~/.Xauthority "$XAUTHORITY"
    '';

    variables = {
      # Conform more programs to XDG conventions. The rest are handled by their
      # respective modules.
      __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      ASPELL_CONF = ''
        per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;
        personal $XDG_CONFIG_HOME/aspell/en_US.pws;
        repl $XDG_CONFIG_HOME/aspell/en.prepl;
      '';
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      HISTFILE = "$XDG_DATA_HOME/bash/history";
      INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
      LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
      WGETRC = "$XDG_CONFIG_HOME/wgetrc";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      # Hardware cursors are currently broken on nvidia
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    sessionVariables = {
      # These are the defaults, and xdg.enable does set them, but due to load
      # order, they're not set before environment.variables are set, which could
      # cause race conditions.
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";

      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      EGL_PLATFORM = "wayland";
      # Hardware cursors are currently broken on nvidia
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
    };

    systemPackages =
      (with pkgs.gnome; [
        zenity
        dconf-editor
        gnome-keyring
        nautilus # File manager
        gnome-disk-utility # Disks manager
        gucharmap # GNOME Character Map
        zenity
        dconf-editor
        nixos-gsettings-overrides
      ])
      ++ (with pkgs; [
        gtk3
        dconf
        gsound
        gcr
        polkit_gnome
        ananicy-cpp-rules
        input-leap_git
        catppuccin-gtk
        catppuccin-kvantum
        glib
        gsettings-qt
        gsettings-desktop-schemas
      ]);
  };

  chaotic.appmenu-gtk3-module.enable = true;

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
        #autoLogin.enable = true;
        #autoLogin.user = "iggut";
        gdm = {
          enable = true;
          #wayland = false;
        };
      };
    };

    accounts-daemon.enable = true;

    gnome.glib-networking.enable = true;

    gnome.gnome-settings-daemon.enable = true;

    upower.enable = config.powerManagement.enable;

    gvfs.enable = true;
  };

  # Workaround for GDM autologin
  #systemd.services = {
  #  "getty@tty1".enable = false;
  #  "autovt@tty1".enable = false;
  #};

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
    partition-manager.enable = true;
    hyprland = {
      enableNvidiaPatches = true;
      enable = true;
      package = pkgs.hyprland;
      xwayland = {
        enable = true;
      };
    };
  };
}
