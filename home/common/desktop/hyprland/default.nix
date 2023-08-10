{
  hostname,
  lib,
  pkgs,
  theme,
  config,
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
    enable = true;
    package = pkgs.hyprland;
    systemdIntegration = true;

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

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
        workspace_swipe_invert = false;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        repeat_rate = 50;
        repeat_delay = 300;
      };

      decoration = {
        rounding = 8;
        drop_shadow = true;
        #blur = true;
        #blur_passes = 3;
        #blur_size = 5;
        #blur_new_optimizations = true;
        multisample_edges = true;
        active_opacity = 0.96;
        inactive_opacity = 0.85;
        fullscreen_opacity = 1.0;
        shadow_ignore_window = true;
        shadow_offset = "0 5";
        shadow_range = 50;
        shadow_render_power = 3;
        "col.shadow" = "rgba(00000099)";
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "workspaces, 1, 6, default, slide"
        ];
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        # disable dragging animation
        animate_mouse_windowdragging = false;
        no_direct_scanout = false; #for fullscreen games
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
}
