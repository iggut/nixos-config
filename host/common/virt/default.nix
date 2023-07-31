{
  desktop,
  lib,
  ...
}: {
  imports =
    [
      ./embr.nix
      ./docker.nix
      #./lxd.nix
      ./multipass.nix
      ./qemu.nix
    ] # Include quickemu if a desktop is defined
    ++ lib.optional (builtins.isString desktop) ./quickemu.nix;
}
