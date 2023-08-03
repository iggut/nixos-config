{theme, ...}: let
  inherit ((import ./file-associations.nix)) associations;
in {
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    desktopEntries = {
      rambox = {
        name = "Rambox";
        exec = "rambox --ozone-platform-hint=auto --enable-features=UseOzonePlatform";
        terminal = false;
        icon = "rambox";
        type = "Application";
        categories = ["Network" "Application"];
      };

      bottles = {
        name = "Bottles";
        exec = "env GTK_THEME=${theme.gtkTheme.name} bottles";
        terminal = false;
        type = "Application";
        icon = "com.usebottles.bottles";
        categories = ["Utility" "GNOME" "GTK"];
        startupNotify = true;
        mimeType = ["x-scheme-handler/bottles" "application/x-ms-dos-executable" "application/x-msi" "application/x-ms-shortcut" "application/x-wine-extension-msp"];
        settings = {
          X-GNOME-UsesNotifications = "true";
        };
      };

      signal-desktop = {
        name = "Signal";
        exec = "signal-desktop --ozone-platform-hint=auto --enable-features=UseOzonePlatform --no-sandbox";
        terminal = false;
        icon = "signal-desktop";
        type = "Application";
        categories = ["Network" "Application"];
      };

      # Override the desktop file for Nautilus to use GTK_THEME.
      # Later versions of Nautilus rely on libadwaita, which doesn't respect the GTK config
      "org.gnome.Nautilus" = {
        name = "Files";
        exec = "env GTK_THEME=${theme.gtkTheme.name} nautilus --new-window";
        terminal = false;
        icon = "org.gnome.Nautilus";
        type = "Application";
        categories = ["GNOME" "Utility" "Core" "FileManager"];
        startupNotify = true;
        settings = {
          DBusActivatable = "true";
          X-GNOME-UsesNotifications = "true";
        };
        mimeType = [
          "inode/directory"
          "application/x-7z-compressed"
          "application/x-7z-compressed-tar"
          "application/x-bzip"
          "application/x-bzip-compressed-tar"
          "application/x-compress"
          "application/x-compressed-tar"
          "application/x-cpio"
          "application/x-gzip"
          "application/x-lha"
          "application/x-lzip"
          "application/x-lzip-compressed-tar"
          "application/x-lzma"
          "application/x-lzma-compressed-tar"
          "application/x-tar"
          "application/x-tarz"
          "application/x-xar"
          "application/x-xz"
          "application/x-xz-compressed-tar"
          "application/zip"
          "application/gzip"
          "application/bzip2"
          "application/vnd.rar"
        ];
      };
    };
  };
}
