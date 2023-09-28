rec {
  colours = rec {
    inherit (catppuccin-mocha) pink red yellow green;
    inherit (catppuccin-mocha) subtext0 subtext1 text;
    inherit (catppuccin-mocha) overlay0 overlay1 overlay2;
    inherit (catppuccin-mocha) surface0 surface1 surface2;

    accent = darkBlue;
    black = catppuccin-mocha.crust;
    white = catppuccin-mocha.rosewater;
    lightPink = catppuccin-mocha.flamingo;
    lightRed = catppuccin-mocha.maroon;
    orange = catppuccin-mocha.peach;
    cyan = catppuccin-mocha.teal;
    blue = catppuccin-mocha.sapphire;
    darkBlue = catppuccin-mocha.blue;
    lightBlue = catppuccin-mocha.sky;
    purple = catppuccin-mocha.mauve;
    lightPurple = catppuccin-mocha.lavender;
    bg = catppuccin-mocha.base;
    bgDark = catppuccin-mocha.mantle;
  };

  catppuccin-mocha = {
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
