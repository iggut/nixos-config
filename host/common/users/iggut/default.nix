{
  pkgs,
  config,
  ...
}: let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.iggut = {
    isNormalUser = true;
    initialPassword = "nixos";
    shell = pkgs.zsh;
    extraGroups =
      [
        "audio"
        "networkmanager"
        "users"
        "video"
        "wheel"
        "libvirtd"
        "kvm"
        "disk"
        "adbusers"
        "media"
        "input"
        "dialout"
        "plugdev"
        "lxd"
      ]
      ++ ifExists [
        "docker"
        "render"
      ];

    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMntn36Qko/UqC8tFNaVBgJUtzA/jD4FmJQ0SY5g94KgAAAACXNzaDppZ2d1dA== YK5C"
    ];

    packages = [pkgs.home-manager];
  };

  # This is a workaround for not seemingly being able to set $EDITOR in home-manager
  environment.sessionVariables = {
    EDITOR = "lite-xl";
  };
}
