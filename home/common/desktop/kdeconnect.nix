{
  lib,
  config,
  pkgs,
  ...
}: {
  services.kdeconnect.indicator = true;
  systemd.user.services.kdeconnect-indicator.Service.Environment = lib.mkForce [
    "LANG=en_US.UTF-8"
    "LC_ALL=en_US.UTF-8"
    "PATH=${config.home.profileDirectory}/bin"
    "QT_PLUGIN_PATH=/run/current-system/sw/${pkgs.qt5.qtbase.qtPluginPrefix}"
  ];
  systemd.user.services.kdeconnect-indicator.Unit.After = ["graphical-session.target" "desktop-panel.service"];
}
