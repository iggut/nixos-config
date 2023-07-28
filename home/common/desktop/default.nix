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
  ];

  fonts.fontconfig.enable = true;
}
