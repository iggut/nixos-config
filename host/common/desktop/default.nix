{
  desktop,
  pkgs,
  theme,
  inputs,
  config,
  lib,
  ...
}: let
  programs = lib.makeBinPath [
    config.programs.hyprland.package
    pkgs.coreutils
    pkgs.power-profiles-daemon
  ];

  startscript = pkgs.writeShellScript "gamemode-start" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
    hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:vfr 0'
    powerprofilesctl set performance
    systemctl --user --machine=1000@ stop clight
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
    hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:vfr 1'
    powerprofilesctl set power-saver
    systemctl --user --machine=1000@ start clight
  '';
in {
  imports = [
    (./. + "/${desktop}.nix")
    ../hardware/ledger.nix
    ../hardware/yubikey.nix
    ../services/pipewire.nix
    ../virt
  ];

  # Enable Plymouth + theme and surpress some logs by default.
  boot.plymouth = {
    enable = true;
    themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
    theme = "catppuccin-mocha";
  };

  boot.kernelParams = [
    # The 'splash' arg is included by the plymouth option - I'm too lazy to check  so I put it in anyway
    "quiet"
    "splash"
    "loglevel=3"
    "rd.udev.log_priority=3"
    "vt.global_cursor_default=0"
  ];
  # improvement for games using lots of mmaps (same as steam deck)
  boot.kernel.sysctl = {"vm.max_map_count" = 2147483642;};

  # Automatically tune nice levels
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  hardware = {
    steam-hardware.enable = true;
    # xpadneo.enable = true;
  };

  # Enable location services
  location.provider = "geoclue2";

  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["iggut"];
    };

    dconf.enable = true;

    # Archive manager
    file-roller.enable = true;

    # Enable gamemode
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 10;
        };
        custom = {
          start = "notify-send -a 'Gamemode' 'Optimizations activated'";
          end = "notify-send -a 'Gamemode' 'Optimizations deactivated'";
        };
      };
    };

    steam = {
      enable = true;
      #gamescopeSession.enable = true;
      #gamescopeSession.args = ["--prefer-vk-device 8086:9bc4"];
    };
  };

  #security.wrappers.gamescope = {
  #  source = "${pkgs.gamescope_git}/bin/gamescope";
  #  program = "gamescope";
  #  capabilities = "cap_sys_nice+ep";
  #  owner = "root";
  #  group = "root";
  #};

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk]; # Needed for steam file picker

  environment.variables = {
    GTK_THEME = "Catppuccin-Mocha-Compact-Mauve-dark";
    GTK_ICON_THEME = "Papirus-Dark";
  };

  environment.etc = {
    "xdg/gtk-2.0/gtkrc" = {
      mode = "444";
      text = ''
        gtk-theme-name = "${config.environment.variables.GTK_THEME}"
        gtk-icon-theme-name = "${config.environment.variables.GTK_ICON_THEME}"
      '';
    };
    "xdg/gtk-3.0/settings.ini" = {
      mode = "444";
      text = ''
        [Settings]
        gtk-theme-name = ${config.environment.variables.GTK_THEME}
        gtk-icon-theme-name = ${config.environment.variables.GTK_ICON_THEME}
      '';
    };
  };

  environment.extraInit = ''
    export XDG_CONFIG_DIRS="/etc/xdg:$XDG_CONFIG_DIRS"
    export RUST_BACKTRACE=1
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-${pkgs.gsettings-desktop-schemas.version}
  '';

  fonts = {
    packages = with pkgs; [
      liberation_ttf
      ubuntu_font_family
      nerdfonts

      theme.fonts.default.package
      theme.fonts.emoji.package
      theme.fonts.iconFont.package
      theme.fonts.monospace.package
    ];

    # Use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["${theme.fonts.default.name}" "${theme.fonts.emoji.name}"];
        sansSerif = ["${theme.fonts.default.name}" "${theme.fonts.emoji.name}"];
        monospace = ["${theme.fonts.monospace.name}"];
        emoji = ["${theme.fonts.emoji.name}"];
      };
    };
  };
}
