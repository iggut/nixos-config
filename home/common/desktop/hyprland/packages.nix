{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    catppuccin-kvantum
    grim

    mpd
    swaybg
    #sfwbar #task bar - tray again one day

    glib
    #gsettings-qt
    gsettings-desktop-schemas
    gnome.dconf-editor
    gnome.nixos-gsettings-overrides
    lxappearance-gtk2
    #nerdfonts
    discord
    betterdiscordctl

    ##eww experiment##
    eww-wayland
    pywal
    poetry
    python311Packages.build
    python311Packages.pillow
    bc
    bluez
    boost
    findutils
    fish
    fuzzel
    ibus
    imagemagick
    libqalculate
    light
    nlohmann_json
    libsForQt5.plasma-browser-integration
    procps
    ripgrep
    socat
    sox
    util-linux
    yad
    cava
    lexend
    #geticons #cant find this
    gojq
    gtklock
    gtklock-playerctl-module
    gtklock-powerbar-module
    gtklock-userinfo-module
    python311Packages.material-color-utilities
    swww
    ##eww experiment##

    zeroad
    cataclysm-dda-git
    shattered-pixel-dungeon
    trackballs
    mari0
    grimblast
    libva-utils
    playerctl
    slurp
    wdisplays
    wf-recorder
    wl-clipboard
    wmctrl
  ];
}
