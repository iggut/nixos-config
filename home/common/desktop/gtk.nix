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

  gtk = {
    enable = true;

    font = {
      inherit (theme.fonts.default) package;
      name = "${theme.fonts.default.name}, ${theme.fonts.default.size}";
    };

    gtk2 = {
      extraConfig = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    iconTheme = {
      inherit (theme.iconTheme) name package;
    };

    theme = theme.gtkTheme;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};
    "org/gnome/shell/extensions/user-theme" = {
      name = "Catppuccin-Mocha-Compact-Mauve-dark";
    };
  };
}
