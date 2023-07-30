{pkgs, ...}: {
  home.packages = with pkgs; [
    catppuccin-kvantum
    grim

    glib
    gsettings-qt
    gsettings-desktop-schemas
    gnome.dconf-editor
    gnome.nixos-gsettings-overrides

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
