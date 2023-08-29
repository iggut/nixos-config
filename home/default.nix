{
  config,
  desktop,
  lib,
  outputs,
  stateVersion,
  username,
  inputs,
  pkgs,
  ...
}: {
  # Only import desktop configuration if the host is desktop enabled
  # Only import user specific configuration if they have bespoke settings
  imports =
    [
      # If you want to use modules your own flake exports (from modules/home-manager):
      # outputs.homeManagerModules.example

      # Or modules exported from other flakes (such as nix-colors):
      # inputs.nix-colors.homeManagerModules.default
      inputs.nix-index-database.hmModules.nix-index

      ./common/shell
    ]
    ++ lib.optional (builtins.isString desktop) ./common/desktop
    ++ lib.optional (builtins.pathExists (./. + "/common/users/${username}")) ./common/users/${username};

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
    activation.report-changes = config.lib.dag.entryAnywhere ''
      ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
    '';
  };

  nixpkgs = {
    overlays =
      [
        # Add overlays your own flake exports (from overlays and pkgs dir):
        outputs.overlays.additions
        outputs.overlays.modifications

        # You can also add overlays exported from other flakes:
        inputs.crafts.overlay
        inputs.nur.overlay
      ]
      ++ lib.optionals (desktop == "hyprland") [
        inputs.hyprland.overlays.default
        inputs.hyprland-contrib.overlays.default
      ];

    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "electron-21.4.0"
      ];
    };
  };
}
