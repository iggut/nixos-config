{
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  inherit ((import ./colours.nix)) colours;
  libx = import ./lib.nix {inherit lib;};

  pkgs = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    overlays = [outputs.overlays.fonts];
    config = {
      allowUnfree = true;
      joypixels.acceptLicense = true;
    };
  };
in {
  inherit (libx) hexToRgb;

  # Note that there are still places not covered by colour choices here such as:
  #  - bat
  #  - tmux
  #  - vim
  inherit colours;

  wallpaper = ./wallpapers/space-clouds.png;

  gtkTheme = {
    name = "Catppuccin-Mocha-Compact-Mauve-Dark";
    package = pkgs.catppuccin-gtk.override {
      accents = ["mauve"];
      size = "compact";
      variant = "mocha";
    };
  };

  qtTheme = {
    name = "Catppuccin-Mocha-Mauve";
    package = pkgs.catppuccin-kvantum.override {
      variant = "Mocha";
      accent = "Mauve";
    };
  };

  iconTheme = rec {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
    iconPath = "${package}/share/icons/${name}";
  };

  cursorTheme = {
    name = "Catppuccin-Frappe-Dark";
    package = pkgs.catppuccin-cursors;
    size = 24;
  };

  fonts = {
    default = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.sf-pro-fonts;
      size = "10";
    };
    iconFont = {
      name = "Liga SFMono Nerd Font";
      package = pkgs.sf-pro-fonts;
    };
    monospace = {
      name = "MesloLGSDZ Nerd Font Mono";
      package = pkgs.nerdfonts.override {fonts = ["Meslo"];};
    };
    emoji = {
      name = "Joypixels";
      package = pkgs.joypixels;
    };
  };
}
