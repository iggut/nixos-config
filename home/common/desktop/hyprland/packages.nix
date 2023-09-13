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
    sfwbar

    glib
    #gsettings-qt
    gsettings-desktop-schemas
    gnome.dconf-editor
    gnome.nixos-gsettings-overrides
    lxappearance-gtk2
    #nerdfonts
    discord

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
