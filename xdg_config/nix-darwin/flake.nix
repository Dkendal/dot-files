{
  description = "System Flake";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs-unstable, nixpkgs, home-manager, ... }:
    let
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit (prev) system;
          config.allowUnfree = true;
        };
      };
      configuration = { ... }:
        {
          imports = [ ./common.nix ./dev.nix ];
          nixpkgs.overlays = [ overlay-unstable ];
          system.configurationRevision = self.rev or self.dirtyRev or null;
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "before-home-manager";
        };
    in
    {
      # Personal computer
      darwinConfigurations."Titania" =
        let
          user = "dylan";
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = { user = user; };
          modules = [
            configuration
            ./home/platforms/darwin.nix
            home-manager.darwinModules.home-manager
            { home-manager.users.${user} = import ./home.nix; }
          ];
        };

      # Work computer
      darwinConfigurations."dylankendal-mbp" =
        let
          user = "dylan.kendal";
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = { user = user; };
          modules = [
            configuration
            ./home/platforms/darwin.nix
            home-manager.darwinModules.home-manager
            { home-manager.users.${user} = import ./home.nix; }
          ];
        };

      # Desktop
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { user = "dylan"; };
        modules = [
          configuration
          ./home/platforms/linux.nix
          home-manager.nixosModules.home-manager
          { home-manager.users.dylan = import ./home.nix; }
        ];
      };
    };
}
