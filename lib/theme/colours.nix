rec {
  colours = rec {
    inherit (catppuccin-macchiato) pink red yellow green;
    inherit (catppuccin-macchiato) subtext0 subtext1 text;
    inherit (catppuccin-macchiato) overlay0 overlay1 overlay2;
    inherit (catppuccin-macchiato) surface0 surface1 surface2;

    accent = darkBlue;
    black = catppuccin-macchiato.crust;
    white = catppuccin-macchiato.rosewater;
    lightPink = catppuccin-macchiato.flamingo;
    lightRed = catppuccin-macchiato.maroon;
    orange = catppuccin-macchiato.peach;
    cyan = catppuccin-macchiato.teal;
    blue = catppuccin-macchiato.sapphire;
    darkBlue = catppuccin-macchiato.blue;
    lightBlue = catppuccin-macchiato.sky;
    purple = catppuccin-macchiato.mauve;
    lightPurple = catppuccin-macchiato.lavender;
    bg = catppuccin-macchiato.base;
    bgDark = catppuccin-macchiato.mantle;
  };

  catppuccin-macchiato = {
    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    maroon = "#eba0ac";
    peach = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#87b0f9";
    lavender = "#b4befe";

    text = "#c6d0f5";
    subtext1 = "#b3bcdf";
    subtext0 = "#a1a8c9";
    overlay2 = "#8e95b3";
    overlay1 = "#7b819d";
    overlay0 = "#696d86";
    surface2 = "#565970";
    surface1 = "#43465a";
    surface0 = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
  };
}
