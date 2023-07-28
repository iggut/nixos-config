{
  description = "iggut's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs-unstable";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";

    sf-pro-fonts-src.url = "github:jnsgruk/sf-pro-fonts";
    sf-pro-fonts-src.flake = false;

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";

    vscode-server.url = "github:msteen/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    crafts.url = "github:jnsgruk/crafts-flake"; # url = "path:/home/iggut/crafts-flake";
    crafts.inputs.nixpkgs.follows = "nixpkgs-unstable";
    embr.url = "github:jnsgruk/firecracker-ubuntu";
    embr.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nix-formatter-pack,
    chaotic,
    ...
  } @ inputs: let
    inherit (self) outputs;
    stateVersion = "23.05";
    username = "iggut";

    libx = import ./lib {inherit inputs outputs stateVersion username;};
  in {
    # nix build .#homeConfigurations."iggut@gaminix".activationPackage
    homeConfigurations = {
      # Desktop machines
      "${username}@freyja" = libx.mkHome {
        hostname = "freyja";
        desktop = "hyprland";
      };
      "${username}@gaminix" = libx.mkHome {
        hostname = "gaminix";
        desktop = "hyprland";
      };
      # Headless machines
      "${username}@hugin" = libx.mkHome {hostname = "hugin";};
      "${username}@thor" = libx.mkHome {hostname = "thor";};
      "ubuntu@dev" = libx.mkHome {
        hostname = "dev";
        user = "ubuntu";
      };
    };

    # nix build .#nixosConfigurations.gaminix.config.system.build.toplevel
    nixosConfigurations = {
      # Desktop machines
      freyja = libx.mkHost {
        hostname = "freyja";
        desktop = "hyprland";
      };
      gaminix = libx.mkHost {
        hostname = "gaminix";
        desktop = "hyprland";
      };
      # Headless machines
      hugin = libx.mkHost {
        hostname = "hugin";
        pkgsInput = nixpkgs;
      };
      thor = libx.mkHost {
        hostname = "thor";
        pkgsInput = nixpkgs;
      };
    };

    # Custom packages; acessible via 'nix build', 'nix shell', etc
    packages = libx.forAllSystems (
      system: let
        pkgs = nixpkgs-unstable.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );

    # Custom overlays
    overlays = import ./overlays {inherit inputs;};

    # Devshell for bootstrapping
    # Accessible via 'nix develop' or 'nix-shell' (legacy)
    devShells = libx.forAllSystems (
      system: let
        pkgs = nixpkgs-unstable.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    formatter = libx.forAllSystems (
      system:
        nix-formatter-pack.lib.mkFormatter {
          pkgs = nixpkgs-unstable.legacyPackages.${system};
          config.tools = {
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            statix.enable = true;
          };
        }
    );

    nixConfig = {
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://jnsgruk.cachix.org"
        "https://nyx.chaotic.cx"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "jnsgruk.cachix.org-1:Kf9JahXxCf0ElU+Uz7xKvQEQHfUtg2Z45N2NeTxuxV8="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
    };
  };
}
