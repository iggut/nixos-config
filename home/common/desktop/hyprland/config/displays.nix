_: {
  gaminix = {
    workspace = [
      "1, monitor: HDMI-A-1"
      "2, monitor: DP-1"
      "3, monitor: DP-1"
      "4, monitor: DP-1"
      "5, monitor: DP-1"
      "6, monitor: HDMI-A-1"
      "7, monitor: HDMI-A-1"
    ];

    monitor = [
      "DP-1,1920x1080@165,0x0,1"
      "HDMI-A-1,2560x1440@60,1920x0,1"
    ];
  };

  freyja = {
    workspace = [];
    monitor = ["eDP-1, preferred, auto, 1.5"];
  };
}
