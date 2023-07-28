{ pkgs, desktop, ... }: {
  imports = [
    (./. + "/${desktop}")

    ../dev

    ./alacritty.nix
    ./game.nix
    ./gtk.nix
    ./qt.nix
    ./xdg.nix
    ./zathura.nix
  ];

  programs = {
    firefox.enable = true;
    mpv.enable = true;
    feh.enable = true;
  };

  home.packages = with pkgs; [
    catppuccin-gtk
    cider
    desktop-file-utils
    ght
    google-chrome
    imlib2Full
    libnotify
    obsidian
    pamixer
    pavucontrol
    rambox
    signal-desktop
    xdg-utils
    xorg.xlsclients
    ###
    nwg-drawer
    nwg-dock-hyprland
    btop # System monitor
    nvtop-nvidia
    vulkan-tools
    glxinfo # gpu tools
    gimp # Image editor
    mullvad-vpn # VPN Client
    ntfs3g # Support NTFS drives
    obs-studio # Recording/Livestream
    onlyoffice-bin # Microsoft Office alternative for Linux
    vlc
    cryptomator # Encrypt data - cloud
    qbittorrent
    stremio # Straming platform
    prusa-slicer # 3D printer slicer software for slicing 3D models into printable layers
    inav-configurator # The iNav flight control system configuration tool
    betaflight-configurator # The Betaflight flight control system configuration tool

  ];

  fonts.fontconfig.enable = true;
}
