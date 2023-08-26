{
  config,
  lib,
  theme,
  ...
}: {
  theme = let
    inherit (config.lib.formats.rasi) mkLiteral;
  in {
    "*" = {
      color = mkLiteral "#c0caf5";
      #border = mkLiteral "none";
      #padding = 0;
      font-family = "${theme.fonts.iconFont.name}";
      font-size = 14;
    };

    "window#waybar" = {
      background-color = mkLiteral "transparent";
    };

    "tooltip" = {
      background = mkLiteral "#101320";
      /*
      tooltip background
      */
      border = mkLiteral "2 solid #c0caf5";
      /*
      tooltip border size and color
      */
      border-radius = mkLiteral "5";
      /*
      tooltip rounded corners
      */
    };

    "#clock,
     #battery,
     #window,
     #workspaces,
     #gamemode,
     #pulseaudio,
     #tray,
     #custom-power,
     #idle_inhibitor" = {
      text-shadow = mkLiteral "1 1 2 black";
      /*
      text shadow, offset-x | offset-y | blur-radius | color
      */
      background = mkLiteral "#101320";
      /*
      background color
      */
      margin = mkLiteral "10 4 4 4";
      /*
      empty spaces around
      */
      padding = mkLiteral "4 10";
      /*
      extend pill size, vertical then horizontal
      */
      box-shadow = mkLiteral "1 1 2 1 rgba(0, 0, 0, 0.4)";
      /*
      pill background shadows
      */
      border-radius = mkLiteral "5";
      /*
      rounded corners
      */
    };

    "#custom-power" = {
      margin-right = mkLiteral "10";
    };

    "#workspaces" = {
      padding = mkLiteral "0";
      margin-left = mkLiteral "10";
    };

    "#workspaces button" = {
      padding = mkLiteral "0 4";
      /*
      fit with pill padding, 0 for not haveing duped vertical padding, 4 to make a square (4 value from module padding: ...#clock {padding >>4<< 10})
      */
      border = mkLiteral "2 solid transparent";
      /*
      required by active workspace top color, or the bar will jitter
      */
      transition-property = mkLiteral "background-color, border-top-color";
      /*
      smooth transition for workspace module
      */
      transition-duration = mkLiteral ".1s";
    };

    "#workspaces button.active" = {
      /*
      active workspace
      */
      background = mkLiteral "#101320";
      /*
      background color
      */
      border-top-color = mkLiteral "#7aa2f7";
      /*
      top color
      */
      color = mkLiteral "#a6adc8";
      /*
      icon(text) color
      */
    };

    "#workspaces button:hover" = {
      background = mkLiteral "#181825";
      /*
      hovered workspace color
      */
    };

    "#mode" = {
      font-weight = mkLiteral "bold";
    };

    /*
    -----Indicators----
    */
    "#idle_inhibitor.activated" = {
      color = mkLiteral "${theme.colours.accent}";
    };

    "#battery.charging" = {
      color = mkLiteral "${theme.colours.green}";
    };

    "#battery.warning:not(.charging)" = {
      color = mkLiteral "${theme.colours.orange}";
    };

    "#battery.critical:not(.charging)" = {
      color = mkLiteral "${theme.colours.red}";
    };

    "#temperature.critical" = {
      color = mkLiteral "${theme.colours.red}";
    };
  };
}
