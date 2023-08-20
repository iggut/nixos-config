_: {
  gaminix = {
    workspace = [
      "1, monitor:DP-1"
      "2, monitor:HDMI-A-1, default:true"
      "3, monitor:HDMI-A-1"
      "4, monitor:HDMI-A-1"
      "5, monitor:HDMI-A-1"
      "6, monitor:DP-1"
      "7, monitor:DP-1"
      "8, monitor:DP-1, default:true"
    ];

    monitor = [
      "DP-1,1920x1080@165,0x0,1"
      #"desc:Samsung Electric Company SAMSUNG 0x01000E00,2560x1440@60,1920x0,1"
      "HDMI-A-1,2560x1440@60,1920x0,1"
      "HDMI-A-3,disable"
    ];
  };

  gs66 = {
    workspace = [];
    monitor = ["eDP-1, preferred, auto, 1"];
  };
}
