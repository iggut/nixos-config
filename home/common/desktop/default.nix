{
  pkgs,
  desktop,
  ...
}: let
  inherit (pkgs.nur.repos.rycee) firefox-addons;
in {
  imports = [
    (./. + "/${desktop}")

    ../dev

    ./alacritty.nix
    ./game.nix
    ./gtk.nix
    ./qt.nix
    ./vscode.nix
    ./xdg.nix
    ./zathura.nix
  ];

  programs = {
    mpv.enable = true;
    feh.enable = true;

    looking-glass-client = {
      enable = true;
      settings = {
        app.allowDMA = true;
        app.shmFile = "/dev/kvmfr0";
        win.showFPS = true;
        spice.enable = true;
      };
    };

    firefox = {
      enable = true;
      profiles.privacy = {
        id = 0;
        name = "privacy";
        extensions = with firefox-addons; [
          reddit-enhancement-suite
          enhancer-for-youtube
          gesturefy
          protondb-for-steam
          istilldontcareaboutcookies
          enhanced-github
          onepassword-password-manager
          darkreader
          ublock-origin
        ];
        search = {
          default = "Google";
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };

            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@nw"];
            };

            "Bing".metaData.hidden = true;
            "DuckDuckGo".metaData.hidden = true;
            "Amazon.nl".metaData.hidden = true;
            "eBay".metaData.hidden = true;
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };
        settings = {
          # Enable HTTPS-Only Mode
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          # Privacy settings
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.partition.network_state.ocsp_cache" = true;
          # Disable all sorts of telemetry
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # As well as Firefox 'experiments'
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "network.allow-experiments" = false;
          # Disable Pocket Integration
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "extensions.pocket.enabled" = false;
          "extensions.pocket.api" = "";
          "extensions.pocket.oAuthConsumerKey" = "";
          "extensions.pocket.showHome" = false;
          "extensions.pocket.site" = "";
          # Allow copy to clipboard
          "dom.events.asyncClipboard.clipboardItem" = true;
        };
      };
    };
  };

  home.packages = with pkgs; [
    catppuccin-gtk
    cider
    desktop-file-utils
    ght
    google-chrome
    imlib2Full
    libnotify
    obsidian
    pamixer
    pavucontrol
    rambox
    signal-desktop
    xdg-utils
    xorg.xlsclients
    ###
    nwg-drawer
    nwg-dock-hyprland
    btop # System monitor
    nvtop-nvidia
    vulkan-tools
    glxinfo # gpu tools
    gimp # Image editor
    mullvad-vpn # VPN Client
    ntfs3g # Support NTFS drives
    obs-studio # Recording/Livestream
    onlyoffice-bin # Microsoft Office alternative for Linux
    vlc
    cryptomator # Encrypt data - cloud
    qbittorrent
    stremio # Straming platform
    prusa-slicer # 3D printer slicer software for slicing 3D models into printable layers
    inav-configurator # The iNav flight control system configuration tool
    betaflight-configurator # The Betaflight flight control system configuration tool
  ];

  home.file = {
    # Add proton-ge-updater script to zsh directory
    ".config/zsh/proton-ge-updater.sh" = {
      source = ./scripts/proton-ge-updater.sh;
      recursive = true;
    };

    # Add steam-library-patcher to zsh directory
    ".config/zsh/steam-library-patcher.sh" = {
      source = ./scripts/steam-library-patcher.sh;
      recursive = true;
    };

    # Add catppuccin mocha steam skin
    ".local/share/Steam/steamui/libraryroot.custom.css" = {
      source = "${(pkgs.callPackage ./self-built/adwaita-for-steam {})}/build/libraryroot.custom.css";
      recursive = true;
    };

    # Enable steam beta
    ".local/share/Steam/package/beta" = {
      text = "publicbeta";
      recursive = true;
    };

    # Add user.js
    ".mozilla/firefox/privacy/user.js" = {
      source = ./config/firefox/user.js;
      recursive = true;
    };

    ".mozilla/firefox/privacy/chrome" = {
      source = ./config/firefox/chrome;
      recursive = true;
    };

    # Add noise suppression microphone
    #".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
    #  source = ./config/pipewire.conf;
    #  recursive = true;
    #};

    # NWG config files
    ".local/share/nwg-dock-hyprland" = {
      source = ./config/nwg/nwg-dock-hyprland;
      recursive = true;
    };
    ".local/share/nwg-drawer" = {
      source = ./config/nwg/nwg-drawer; #might need this: sudo ln -s ~/.local/share/nwg-drawer /usr/share
      recursive = true;
    };

    # Add btop config
    ".config/btop/btop.conf" = {
      source = ./config/btop.conf;
      recursive = true;
    };

    # Add webcord theme
    ".config/WebCord/Themes/comfy" = {
      source = ./config/comfy;
      recursive = true;
    };

    # Add custom mangohud config for CS:GO
    ".config/MangoHud/csgo_linux64.conf" = {
      text = ''
        background_alpha=0
        cpu_color=FFFFFF
        cpu_temp
        engine_color=FFFFFF
        font_size=20
        fps
        fps_limit=0+144
        frame_timing=0
        gamemode
        gl_vsync=0
        gpu_color=FFFFFF
        gpu_temp
        no_small_font
        offset_x=50
        position=top-right
        toggle_fps_limit=Ctrl_L+Shift_L+F1
        vsync=1
      '';
      recursive = true;
    };

    # Add custom mangohud config for CS2
    ".config/MangoHud/wine-cs2.conf" = {
      text = ''
        background_alpha=0
        cpu_color=FFFFFF
        cpu_temp
        engine_color=FFFFFF
        font_size=20
        fps
        fps_limit=0+144
        frame_timing=0
        gamemode
        gl_vsync=0
        gpu_color=FFFFFF
        gpu_temp
        no_small_font
        offset_x=50
        position=top-right
        toggle_fps_limit=Ctrl_L+Shift_L+F1
        vsync=1
      '';
      recursive = true;
    };

    # fix icons for couple custom windows
    ".local/share/applications/startup-alacritty.desktop" = {
      text = ''
        [Desktop Entry]
        Type=Application
        TryExec=alacritty
        Exec=/home/iggut/.local/share/applications/startup-alacritty.sh
        Icon=/home/iggut/.local/share/nwg-dock-hyprland/images/startup-alacritty.svg
        Terminal=false
        Categories=System;TerminalEmulator;
        StartupNotify=true
        Name=startup-alacritty
        GenericName=Terminal
        Comment=A fast, cross-platform, OpenGL terminal emulator
        Actions=New;

        [Desktop Action New]
        Name=New Terminal
        Exec=alacritty
      '';
      recursive = true;
    };
    ".local/share/applications/task-managers.desktop" = {
      text = ''
        [Desktop Entry]
        Type=Application
        TryExec=alacritty
        Exec=/home/iggut/.local/share/applications/task-managers.sh
        Icon=/home/iggut/.local/share/nwg-dock-hyprland/images/task-managers.svg
        Terminal=false
        Categories=System;TerminalEmulator;
        StartupNotify=true
        Name=task-managers
        GenericName=Terminal
        Comment=A fast, cross-platform, OpenGL terminal emulator
        StartupWMClass=task-managers
        Actions=New;

        [Desktop Action New]
        Name=New Terminal
        Exec=alacritty
      '';
      recursive = true;
    };
  };

  fonts.fontconfig.enable = true;
}
