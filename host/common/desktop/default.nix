{
  desktop,
  pkgs,
  theme,
  ...
}: {
  imports = [
    (./. + "/${desktop}.nix")
    ../hardware/ledger.nix
    ../hardware/yubikey.nix
    ../services/pipewire.nix
    ../virt
  ];

  # Enable Plymouth and surpress some logs by default.
  boot.plymouth.enable = true;
  boot.kernelParams = [
    # The 'splash' arg is included by the plymouth option
    "quiet"
    "loglevel=3"
    "rd.udev.log_priority=3"
    "vt.global_cursor_default=0"
  ];
  # improvement for games using lots of mmaps (same as steam deck)
  boot.kernel.sysctl = {"vm.max_map_count" = 2147483642;};

  hardware.opengl.enable = true;

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

    #Enable Gamescope
    gamescope = {
      enable = true;
      package = pkgs.gamescope;
      capSysNice = true;
      #args = ["--prefer-vk-device 8086:9bc4"];
    };

  };

  fonts = {
    fonts = with pkgs; [
      liberation_ttf
      ubuntu_font_family

      theme.fonts.default.package
      theme.fonts.emoji.package
      theme.fonts.iconFont.package
      theme.fonts.monospace.package
    ];

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
