{
  pkgs,
  config,
  ...
}: {
  systemd.user.services.blueman-applet = {
    Unit = {
      Description = "launch blueman-applet";
      After = ["graphical-session.target" "desktop-panel.service"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.blueman}/bin/blueman-applet";
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "LANG=en_US.UTF-8"
        "LC_ALL=en_US.UTF-8"
      ];
      Restart = "always";
    };

    Install = {WantedBy = ["graphical-session.target"];};
  };
}
