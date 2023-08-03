{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    lite-xl
  ];

  ".config/lite-xl/init.lua" = {
    source = ./init.lua;
    recursive = true;
  };
}
