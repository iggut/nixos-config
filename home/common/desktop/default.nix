{ pkgs, desktop, ... }:
let inherit (pkgs.nur.repos.rycee) firefox-addons;
in {
  imports = [
    (./. + "/${desktop}")

    ./dev

    ./alacritty.nix
    ./game.nix
    ./gtk.nix
    ./qt.nix
    ./xdg.nix
    ./zathura.nix
  ];

  programs = {
    mpv.enable = true;
    feh.enable = true;

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

    # Add user.js
    ".mozilla/firefox/privacy/user.js" = {
      source = ./configs/firefox/user.js;
      recursive = true;
    };

    # Import firefox gnome theme userChrome.css
    ".mozilla/firefox/privacy/chrome/userChrome.css" = {
      source = ./configs/firefox/userChrome.css;
      recursive = true;
    };

    # Import firefox gnome theme userContent.css
    ".mozilla/firefox/privacy/chrome/userContent.css" = {
      source = ./configs/firefox/userContent.css;
      recursive = true;
    };

    # Import firefox gnome theme files
    ".mozilla/firefox/privacy/chrome/cleaner_extensions_menu.css" = {
      source = ./configs/firefox/cleaner_extensions_menu.css;
      recursive = true;
    };
    ".mozilla/firefox/privacy/chrome/firefox_view_icon_change.css" = {
      source = ./configs/firefox/firefox_view_icon_change.css;
      recursive = true;
    };
    ".mozilla/firefox/privacy/chrome/spill-style-part1-file.css" = {
      source = ./configs/firefox/spill-style-part1-file.css;
      recursive = true;
    };
    ".mozilla/firefox/privacy/chrome/colored_soundplaying_tab.css" = {
      source = ./configs/firefox/colored_soundplaying_tab.css;
      recursive = true;
    };
    ".mozilla/firefox/privacy/chrome/popout_bookmarks_bar_on_hover.css" = {
      source = ./configs/firefox/popout_bookmarks_bar_on_hover.css;
      recursive = true;
    };
    ".mozilla/firefox/privacy/chrome/spill-style-part2-file.css" = {
      source = ./configs/firefox/spill-style-part2-file.css;
      recursive = true;
    };
    ".mozilla/firefox/privacy/chrome/image" = {
      source = ./configs/firefox/image;
      recursive = true;
    };


    # Add noise suppression microphone
    #".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
    #  source = ./configs/pipewire.conf;
    #  recursive = true;
    #};

    # NWG config files
    ".local/share/nwg-dock-hyprland" = {
      source = ./configs/nwg/nwg-dock-hyprland;
      recursive = true;
    };
    ".local/share/nwg-drawer" = {
      source = ./configs/nwg/nwg-drawer; #might need this: sudo ln -s ~/.local/share/nwg-drawer /usr/share
      recursive = true;
    };

    # Add btop config
    ".config/btop/btop.conf" = {
      source = ./configs/btop.conf;
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

  };

  fonts.fontconfig.enable = true;
}
