{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    lite-xl
  ];
  home.file = {
    ".config/lite-xl/init.lua" = {
      source = ../desktop/config/init.lua;
      recursive = true;
    };
    ".config/lite-xl/fonts/SymbolsNerdFont-Regular.ttf" = {
      source = ../desktop/config/SymbolsNerdFont-Regular.ttf;
      recursive = true;
    };
  };
}
