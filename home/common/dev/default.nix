{
  desktop,
  lib,
  ...
}: {
  imports =
    [
      ./charm-tools.nix
      ./cloud.nix
      ./containers.nix
      ./go.nix
      ./litexl.nix
      ./nix.nix
      ./shell.nix
      ./python.nix
    ]
    ++ lib.optional (builtins.isString desktop) ./desktop.nix;
}
