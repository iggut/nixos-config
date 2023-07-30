{
  pkgs,
  theme,
  ...
}: {
  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };

  home = {
    packages = with pkgs; [
      theme.qtTheme.package
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      lxqt.lxqt-panel
      lxqt.lxqt-themes
      lxqt.lxqt-config
      lxqt.lxqt-qtplugin
      catppuccin-kvantum
    ];
    sessionVariables = {
      "QT_STYLE_OVERRIDE" = "kvantum";
    };
  };

  #xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
  #  General.theme = "${theme.qtTheme.name}"; #"Catppuccin-Mocha-Mauve";
  #};
}
