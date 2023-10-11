{
  hostname,
  lib,
  pkgs,
  theme,
  config,
  inputs,
  ...
}: let
  keybinds = builtins.readFile ./config/keybinds.conf;
  hyprexec = builtins.readFile ./config/hyprexec.conf;
  outputs = (import ./config/displays.nix {}).${hostname};
  windowRules = import ./config/window-rules.nix {};
in {
  imports = [
    ../rofi
    ../waybar

    ../mako.nix
    ../swappy.nix
    ../swaylock.nix
    ../wl-common.nix

    ./packages.nix
  ];

  wayland.windowManager.hyprland = {
    enableNvidiaPatches = true;

    enable = true;
    package = pkgs.hyprland;
    systemd.enable = true;

    xwayland = {
      enable = true;
    };

    settings = {
      inherit (outputs) monitor workspace;
      inherit (windowRules) windowrulev2;

      "$mod" = "SUPER";

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 0;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        repeat_rate = 50;
        repeat_delay = 300;
        touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
          clickfinger_behavior = true;
          scroll_factor = 0.5;
        };
        scroll_method = "2fg";
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
        workspace_swipe_invert = true;
        workspace_swipe_distance = "1200px";
        workspace_swipe_fingers = 3;
        workspace_swipe_cancel_ratio = 0.2;
        workspace_swipe_min_speed_to_force = 5;
        workspace_swipe_create_new = true;
      };

      decoration = {
        rounding = 8;
        drop_shadow = true;
        blur = {
          enabled = false;
          size = 5;
          passes = 2;
          contrast = 0.8916;
          brightness = 0.8172;
          new_optimizations = true;
          ignore_opacity = true;
          special = true;
        };
        #multisample_edges = true;
        active_opacity = 0.97;
        inactive_opacity = 0.88;
        fullscreen_opacity = 1.0;
        shadow_ignore_window = true;
        shadow_offset = "0 5";
        shadow_range = 50;
        shadow_render_power = 3;
        "col.shadow" = "rgba(00000099)";
      };

      animations = {
        enabled = true;
        # Animation curves
        bezier = [
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "fluent_decel, 0.1, 1, 0, 1"
        ];
        # Animation configs
        animation = [
          "windows, 1, 2, md3_decel, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 2, default"
          "workspaces, 1, 3, md3_decel"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        # disable dragging animation
        animate_mouse_windowdragging = false;
        animate_manual_resizes = false;
        focus_on_activate = true;
        no_direct_scanout = true; #for fullscreen games
        vfr = "1";
        vrr = "1";
      };
    };

    extraConfig = ''
      ${keybinds}
      ${hyprexec}
    '';
  };

  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  systemd.user.services.swaybg = {
    Unit.Description = "swaybg";
    Install.WantedBy = ["hyprland-session.target"];
    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${theme.wallpaper}";
      Restart = "on-failure";
    };
  };

  systemd.user.sessionVariables = {
    PATH = "/run/wrappers/bin:/home/iggut/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
    QT_QPA_PLATFORM = "${config.home.sessionVariables.QT_QPA_PLATFORM}";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORMTHEME = "${config.home.sessionVariables.QT_QPA_PLATFORMTHEME}";
  };

  # Gnome control center running in Hypr WMs
  xdg.desktopEntries.gnome-control-center = {
    exec = "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center";
    icon = "gnome-control-center";
    name = "Gnome Control Center";
    terminal = false;
    type = "Application";
  };

  # Set gnome control center to open in the online accounts submenu
  dconf.settings."org/gnome/control-center".last-panel = "online-accounts";

  xdg.configFile = let
    files = builtins.readDir ../eww/config;
    splitList = let
      splitList = n: list:
        if lib.length list == 0
        then []
        else let
          chunk = lib.sublist 0 n list;
          rest = splitList n (lib.drop n list);
        in
          [chunk] ++ rest;
    in
      splitList;
  in
    lib.concatMapAttrs (name: _: {
      "eww/${name}" = {
        source = pkgs.substituteAll {
          src = ../eww/config/${name};
          backgroundAlpha = "#585b70";
          pamixer = lib.getExe pkgs.pamixer;
          pactl = "${pkgs.pulseaudio}/bin/pactl";
          jaq = lib.getExe pkgs.jaq;
          socat = lib.getExe pkgs.socat;
          curl = lib.getExe pkgs.curl;
          micName = "Sony Playstation Eye Analog Surround 4.0";
          fish = lib.getExe pkgs.alacritty;
          pidof = "${pkgs.procps}/bin/pidof";
          xargs = "${pkgs.findutils}/bin/xargs";
          idleInhibit = "${pkgs.wlroots.examples}/bin/wlroots-idle-inhibit";
          # done twice so that it's a string
        };
        executable = true;
      };
    })
    files;
}
