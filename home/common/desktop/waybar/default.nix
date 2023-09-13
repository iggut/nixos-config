{
  config,
  pkgs,
  lib,
  hostname,
  desktop,
  theme,
  ...
}: let
  waybar-wttr = pkgs.stdenv.mkDerivation {
    name = "waybar-wttr";
    buildInputs = [
      (pkgs.python39.withPackages
        (pythonPackages: with pythonPackages; [requests]))
    ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      cp ${./waybar-wttr.py} $out/bin/waybar-wttr
      chmod +x $out/bin/waybar-wttr
    '';
  };

  waybar-mediap = pkgs.stdenv.mkDerivation {
    name = "waybar-mediap";
    buildInputs = [
      (pkgs.python39.withPackages
        (pythonPackages: with pythonPackages; [requests]))
    ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      cp ${./waybar-mediap.py} $out/bin/waybar-mediap
      chmod +x $out/bin/waybar-mediap
    '';
  };

  # If this is a laptop, then include network/battery controls
  modules =
    if hostname == "gs66"
    then [
      "tray"
      "idle_inhibitor"
      "network"
      "battery"
      "pulseaudio"
      "pulseaudio#source"
      "clock"
      "custom/power"
    ]
    else [
      "tray"
      "idle_inhibitor"
      "pulseaudio"
      "pulseaudio#source"
      "clock"
      "custom/power"
    ];

  workspaceConfig = {
    format = "{name}:{icon} ";
    format-icons = {
      "1" = "";
      "2" = "";
      "3" = "󰙯";
      "4" = "";
      "5" = "󰘐";
      "6" = "";
      "7" = "";
      "8" = "󰣙";
      "9" = "";
    };
    on-click = "activate";
    on-scroll-up = "hyprctl dispatch workspace e-1";
    on-scroll-down = "hyprctl dispatch workspace e+1";
  };

  windowModule = {
    rewrite = {
      "(.*) .*? Mozilla Firefox$" = " $1";
      "(.*) .*? VSCodium$" = "󰘐 $1";
      "Alacritty$" = " Alacritty";
      "Friends List$" = " Friends";
      "Steam$" = " Steam";
    };
    separate-outputs = true;
  };

  inherit ((import ../rofi/lib.nix {inherit lib;})) toRasi;
  inherit ((import ../rofi/powermenu {inherit config lib desktop pkgs theme;})) rofi-power;
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    systemd = {
      enable = false; #if desktop == "sway" then true else false;
    };

    settings = [
      {
        exclusive = true;
        position = "top";
        layer = "top";
        height = 18;
        passthrough = false;
        gtk-layer-shell = true;

        modules-left = ["hyprland/workspaces" "mpris" "custom/spotify" "custom/weather" "gamemode"];
        modules-center = ["hyprland/window"];
        modules-right = modules;

        "hyprland/workspaces" = workspaceConfig;
        "hyprland/window" = windowModule;

        gamemode = {
          format = "{glyph} {count}";
          glyph = "󰊴";
          hide-not-running = true;
          use-icon = true;
          icon-name = "input-gaming-symbolic";
          icon-spacing = 4;
          icon-size = 20;
          tooltip = true;
          tooltip-format = "Games running: {count}";
        };

        "network" = {
          format-wifi = "{essid} ";
          format-ethernet = "{ifname} ";
          format-disconnected = "";
          tooltip-format = "{ifname} / {essid} ({signalStrength}%) / {ipaddr}";
          max-length = 15;
          on-click = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.networkmanager}/bin/nmtui";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "mpris" = {
          max-length = 40;
          format = "<span foreground='#a6e3a1'>{player_icon}</span> <span foreground='#bb9af7'>{title}</span>";
          format-paused = "{status_icon} <i>{title}</i>";
          player-icons = {
            default = "󰻏 ";
            mpv = "🎵";
          };
          status-icons = {
            paused = "󰾉 ";
          };
          tooltip-format = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
        };

        "custom/weather" = {
          format = "{}";
          tooltip = true;
          interval = 30;
          exec = "${waybar-wttr}/bin/waybar-wttr";
          return-type = "json";
        };

        "custom/spotify" = {
          exec = "${waybar-mediap}/bin/waybar-mediap --player youtube-music";
          format = " {}";
          return-type = "json";
          on-click = "playerctl play-pause";
          on-double-click-right = "playerctl next";
          on-scroll-down = "playerctl previous";
        };

        "battery" = {
          states = {
            good = 95;
            warning = 20;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "";
          tooltip-format = "{time} ({capacity}%)";
          format-alt = "{time} {icon}";
          format-full = "";
          format-icons = ["" "" "" "" ""];
        };

        "tray" = {
          icon-size = 15;
          spacing = 10;
        };

        "clock" = {
          format = "{:%A %H:%M} ";
          on-click = "bash $HOME/.config/waybar/scripts/changewallpaper.sh";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "${pkgs.avizo}/bin/volumectl toggle-mute";
          on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
          tooltip-format = "{volume}% / {desc}";
        };

        "pulseaudio#source" = {
          format = "{format_source}";
          format-source = "";
          format-source-muted = "";
          on-click = "${pkgs.avizo}/bin/volumectl -m toggle-mute";
          on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
          tooltip-format = "{source_volume}% / {desc}";
        };

        "custom/power" = {
          format = "";
          on-click = "${lib.getExe rofi-power} ${desktop}";
        };
      }
    ];

    # This is a bit of a hack. Rasi turns out to be basically CSS, and there is
    # a handy helper to convert nix -> rasi in the home-manager module for rofi,
    # so I'm using that here to render the stylesheet for waybar
    style = toRasi (import ./theme.nix {inherit config pkgs lib theme;}).theme;
  };

  # This is a hack to ensure that hyprctl ends up in the PATH for the waybar service on hyprland
  systemd.user.services.waybar.Service.Environment = lib.mkForce "PATH=${lib.makeBinPath [pkgs."${desktop}"]}";
}
