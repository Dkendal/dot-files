{
  description = "System Flake";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs-unstable, nixpkgs, home-manager, ... }:
    let
      overlay = final: prev: {
        fzf = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.fzf;
      };
      # Portable configuration shared by all hosts; platform-specific
      # settings live in darwin.nix / linux.nix.
      configuration = { ... }:
        {
          imports = [ ./common.nix ./dev.nix ];

          nixpkgs.overlays = [ overlay ];

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # services.tailscale.enable = true;
        };
    in
    {
      # Personal computer
      darwinConfigurations."Titania" =
        let
          user = "dylan";
          unstable = nixpkgs-unstable.legacyPackages."aarch64-darwin";
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = { user = user; };
          modules = [
            configuration
            ./darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "before-home-manager";
              home-manager.extraSpecialArgs = { inherit unstable; };
              home-manager.users.${user} = import ./home.nix;
            }
          ];
        };

      # Work computer
      darwinConfigurations."dylankendal-mbp" =
        let
          user = "dylan.kendal";
          unstable = nixpkgs-unstable.legacyPackages."aarch64-darwin";
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = { user = user; };
          modules = [
            configuration
            ./darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "before-home-manager";
              home-manager.extraSpecialArgs = { inherit unstable; };
              home-manager.users.${user} = import ./home.nix;
            }
          ];
        };

      # Place holder configuration for desktop
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { user = "dylan"; };
        modules = [
          configuration
          ./linux.nix
          home-manager.nixosModules.home-manager
          { home-manager.users.dylan = import ./home.nix; }
        ];
      };
    };
}
