{
  description = "jnsgruk's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    crafts = {
      # url = "path:/home/jon/crafts-flake";
      url = "github:jnsgruk/crafts-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    embr = {
      # url = "path:/home/jon/firecracker-ubuntu";
      url = "github:jnsgruk/firecracker-ubuntu";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;

      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      stateVersion = "23.05";
      theme = import ./lib/theme;
      username = "jon";
    in
    {
      # Custom packages; acessible via 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs-unstable.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );

      # Devshell for bootstrapping
      # Accessible via 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs-unstable.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      formatter = forAllSystems (system:
        let pkgs = nixpkgs-unstable.legacyPackages.${system};
        in pkgs.nixpkgs-fmt
      );

      overlays = import ./overlays { inherit inputs; };

      homeConfigurations = {
        "${username}@freyja" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion theme username;
            hostname = "freyja";
            desktop = "hyprland";
          };
          modules = [ ./home ];
        };

        "${username}@hugin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion theme username;
            hostname = "hugin";
            desktop = null;
          };
          modules = [ ./home ];
        };

        "${username}@kara" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion theme username;
            hostname = "kara";
            desktop = "hyprland";
          };
          modules = [ ./home ];
        };

        "${username}@loki" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion theme username;
            hostname = "loki";
            desktop = null;
          };
          modules = [ ./home ];
        };

        "${username}@thor" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion theme username;
            hostname = "thor";
            desktop = null;
          };
          modules = [ ./home ];
        };

        # Used for running home-manager on Ubuntu under multipass
        "ubuntu@dev" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion theme;
            hostname = "dev";
            desktop = null;
            username = "ubuntu";
          };
          modules = [ ./home ];
        };
      };

      nixosConfigurations = {
        freyja = nixpkgs-unstable.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs stateVersion theme username;
            hostname = "freyja";
            desktop = "hyprland";
          };
          modules = [ ./host ];
        };

        hugin = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs stateVersion theme username;
            hostname = "hugin";
            desktop = null;
          };
          modules = [ ./host ];
        };

        kara = nixpkgs-unstable.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs stateVersion theme username;
            hostname = "kara";
            desktop = "hyprland";
          };
          modules = [ ./host ];
        };

        loki = nixpkgs-unstable.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs stateVersion theme username;
            hostname = "loki";
            desktop = null;
          };
          modules = [ ./host ];
        };

        thor = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs stateVersion theme username;
            hostname = "thor";
            desktop = null;
          };
          modules = [ ./host ];
        };
      };
    };
}
