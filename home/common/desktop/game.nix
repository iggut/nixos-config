{
  pkgs,
  lib,
  user,
  chaotic,
  ...
}: {
  environment.systemPackages = with pkgs; [
    goverlay
    mangohud
    prismlauncher
    lunar-client
    minetest
    osu-lazer-bin
    protonup-qt
    fastfetch
    ananicy-cpp-rules
    input-leap_git
  ];

  hardware = {
    steam-hardware.enable = true;
    # xpadneo.enable = true;
  };

  # Enable gamemode
  programs.gamemode = {
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

  # improvement for games using lots of mmaps (same as steam deck)
  boot.kernel.sysctl = {"vm.max_map_count" = 2147483642;};

  programs.steam = {
    enable = true;
    #gamescopeSession.enable = true;
    #gamescopeSession.args = ["--prefer-vk-device 8086:9bc4"];
  };

  #Enable Gamescope
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope_git;
    capSysNice = true;
    #args = ["--prefer-vk-device 8086:9bc4"];
  };
  #chaotic.steam.extraCompatPackages = with pkgs; [luxtorpeda proton-ge-custom];
  # Chaotic cache
  nix.settings = {
    extra-substituters = [
      "https://nyx.chaotic.cx"
    ];
    extra-trusted-public-keys = [
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ];
  };
}
