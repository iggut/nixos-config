{
  pkgs,
  desktop,
  user,
  self,
  ...
}: {
  home.packages = with pkgs; [
    goverlay
    mangohud
    prismlauncher
    lunar-client
    minetest
    osu-lazer-bin
    protonup-qt
    heroic # Epic Games Launcher for Linux
    bottles # Wine manager
    input-remapper # Remap input device controls
    prismlauncher # Minecraft launcher
    scanmem # Cheat engine for linux
    yuzu-early-access # Nintendo Switch emulator
    rpcs3 # PS3 Emulator
    protontricks # Winetricks for proton prefixes
    wine # Compatibility layer capable of running Windows applications
    winetricks # Wine prefix settings manager
  ];
}
