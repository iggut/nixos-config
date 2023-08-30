{config, ...}: {
  systemd.user.services._1password = {
    Unit = {
      Description = "Autostart for 1password";
      After = ["graphical-session.target" "desktop-panel.service"];
      PartOf = ["graphical-session.target"];
    };

    Install = {WantedBy = ["graphical-session.target"];};

    Service = {
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "LANG=en_US.UTF-8"
        "LC_ALL=en_US.UTF-8"
      ];
      ExecStart = "/run/current-system/sw/bin/1password --silent";
      Restart = "always";
    };
  };
}
