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
     #mpris,
     #custom-power,
     #custom-spotify,
     #custom-weather,
     #custom-weather.severe,
     #custom-weather.sunnyDay,
     #custom-weather.clearNight,
     #custom-weather.cloudyFoggyDay,
     #custom-weather.cloudyFoggyNight,
     #custom-weather.rainyDay,
     #custom-weather.rainyNight,
     #custom-weather.showyIcyDay,
     #custom-weather.snowyIcyNight,
     #custom-weather.default,
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

    "#mpris, #custom-spotify" = {
      color = mkLiteral "#abb2bf";
    };

    "#custom-weather" = {
      font-family = "${theme.fonts.iconFont.name}";
      font-size = mkLiteral "14";
      color = mkLiteral "#8a909e";
    };

    "#custom-weather.severe" = {
      color = mkLiteral "#eb937d";
    };

    "#custom-weather.sunnyDay" = {
      color = mkLiteral "#c2ca76";
    };

    "#custom-weather.clearNight" = {
      color = mkLiteral "#cad3f5";
    };

    "#custom-weather.cloudyFoggyDay,
     #custom-weather.cloudyFoggyNight" = {
      color = mkLiteral "#c2ddda";
    };

    "#custom-weather.rainyDay,
     #custom-weather.rainyNight" = {
      color = mkLiteral "#5aaca5";
    };

    "#custom-weather.showyIcyDay,
     #custom-weather.snowyIcyNight" = {
      color = mkLiteral "#d6e7e5";
    };

    "#custom-weather.default" = {
      color = mkLiteral "#dbd9d8";
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
      transition = mkLiteral "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
      /*
      active workspace
      */
      background = mkLiteral "#181825";
      /*
      background color
      */
      border-top-color = mkLiteral "#7aa2f7";
      /*
      top color
      */
      color = mkLiteral "${theme.colours.blue}";
      /*
      icon(text) color
      */
    };

    "#workspaces button:hover" = {
      background = mkLiteral "#1e1e2e";
      /*
      hovered workspace color
      */
      color = mkLiteral "${theme.colours.blue}";
      box-shadow = mkLiteral "inherit";
      text-shadow = mkLiteral "inherit";
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
