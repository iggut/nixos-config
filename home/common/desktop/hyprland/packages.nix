{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    catppuccin-kvantum
    grim
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
    mpd
    swaybg
    openrgb-with-all-plugins
    qgroundcontrol
    plex
    jdk11
    xorg.libXext
    #sfwbar #task bar - tray again one day
    glib
    gsettings-desktop-schemas
    gnome.dconf-editor
    gnome.nixos-gsettings-overrides
    lxappearance-gtk2
    nerdfonts
    discord
    betterdiscordctl

    ##eww experiment##
    (eww-wayland.overrideAttrs (drv: rec {
      version = "tray-3";
      src = fetchFromGitHub {
        owner = "hylophile";
        repo = "eww";
        rev = "2bfd3af0c0672448856d4bd778042a2ec28a7ca7";
        sha256 = "sha256-t62kQiRhzTL5YO6p0+dsfLdQoK6ONjN47VKTl9axWl4=";
      };
      cargoDeps = drv.cargoDeps.overrideAttrs (lib.const {
        inherit src;
        outputHash = "sha256-3B81cTIVt/cne6I/gKBgX4zR5w0UU60ccrFGV1nNCoA=";
      });
      buildInputs = drv.buildInputs ++ (with pkgs; [glib librsvg libdbusmenu-gtk3]);
    }))
    pulseaudio
    jaq
    socat
    bash
    blueberry
    bluez
    brillo
    findutils
    gawk
    gnused
    imagemagick
    jc
    procps
    udev
    upower
    util-linux
    wlogout
    ##eww experiment##
  ];
}
