{
  theme,
  config,
  pkgs,
  ...
}: {
  home.pointerCursor = {
    inherit (theme.cursorTheme) package size name;
    gtk.enable = true;
    x11.enable = true;
  };
  home.sessionVariables.GTK_THEME = "Tokyonight-Dark-BL";

  gtk = {
    enable = true;

    iconTheme = {
      name = "Tokyonight-Dark-Cyan";
      package = import ./tok.nix;
    };

    theme = {
      name = "Tokyonight-Dark-BL";
      package = import ./tok.nix;
    };

    cursorTheme = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
        gtk-cursor-theme-name=Vanilla-DMZ
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
        gtk-cursor-theme-name=Vanilla-DMZ
      '';
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};
    "org/gnome/shell/extensions/user-theme" = {
      name = "Tokyonight-Dark-BL";
    };
  };
}
