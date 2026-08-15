{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      overlay = find: prev: {
        # neovim = inputs.neovim-nightly-overlay.packages.${prev.stdenv.hostPlatform.system}.default;
        # go-task = nixpkgs-stable.legacyPackages.${prev.system}.go-task;
      };
      configuration = { pkgs, user, ... }:
        let
          unstable = nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs;
            [
              # Core System Utilities
              coreutils # Basic file, shell and text manipulation utilities
              uutils-coreutils-noprefix # Rust implementation of GNU coreutils
              moreutils # Collection of additional Unix utilities
              curl # Command line tool for transferring data with URL syntax
              wget # Non-interactive network downloader
              darwin.trash # macOS trash utility
              rsync

              # File System Navigation & Management
              eza # Modern replacement for ls with Git integration
              fd # Simple, fast and user-friendly alternative to find
              zoxide # Smarter cd command with instant directory jumping
              ranger # Console file manager with VI key bindings
              ov # Modern terminal pager (like less/more)
              tree-sitter # Parser generator tool and incremental parsing library
              rclone # Command line program to sync files and directories
              restic # Backup program with encryption and deduplication
              dust # More intuitive version of du (disk usage)

              # Shell & Terminal
              nushell # Data-driven shell with structured data
              nufmt # Data-driven shell with structured data
              htop # Interactive process viewer
              gum # Tool for glamorous shell scripts
              viddy # Modern watch command (executes command periodically)
              hyperfine # Command-line benchmarking tool

              # Security Tools
              gnupg # GNU Privacy Guard - encryption and signing tool
              gpg-tui # Terminal user interface for GnuPG
              trufflehog # Secret detection in git repositories or files

              # Monitoring & Logging
              entr # Run arbitrary commands when files change
              fswatch # File change monitor
              tailspin # Log file highlighter
              lnav # Log file navigator

              ffmpeg

              _7zz
            ];

          services.tailscale = {
            package = unstable.tailscale;
            enable = true;
          };

          homebrew = {
            enable = true;
            onActivation = {
              cleanup = "none";
              extraFlags = [ "--verbose" ];
              autoUpdate = false;
            };
            taps = [
              "noborus/tap" # trdsql
              "1password/tap"
              "localstack/tap"
            ];
            casks = [
              "1password-cli"
            ];
            brews = [
              "localstack-cli"
              "trdsql"
              "pipx"
              "wxwidgets"
              "flyctl"
              # required for elixir
              "openssl@1.1"
              "autoconf"
              "coreutils"
              "snowflake-cli"
            ];
          };

          # Match the determinate installer ids
          ids.gids.nixbld = 350;

          security.pam.services.sudo_local.touchIdAuth = true;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.trusted-users = [ "root" user ];

          # Binary caches for faster builds
          nix.settings.extra-substituters = [
            "https://nix-community.cachix.org"
          ];
          nix.settings.extra-trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];

          # Parallel builds
          nix.settings.max-jobs = "auto";
          nix.settings.cores = 0; # Use all available cores

          # 500MB
          nix.settings.download-buffer-size = 500000000;

          nix.gc = {
            automatic = true;
            interval.Day = 7; #Hours, minutes
            options = "--delete-older-than 7d";
          };

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ overlay ];

          programs.zsh.enable = true;
          programs.bash.enable = true;
          programs.fish.enable = true;

          users.users.${user} = {
            home = "/Users/${user}";
            shell = pkgs.fish;
          };

          system.primaryUser = user;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          system.defaults = {
            finder = {
              AppleShowAllExtensions = true;
              ShowPathbar = true;
            };

            dock = {
              mru-spaces = false;
              show-recents = false;
            };

            NSGlobalDomain = {
              InitialKeyRepeat = 15;
              KeyRepeat = 2;
            };
          };

          system.stateVersion = 4;

          environment.shells = [ pkgs.fish ];

          environment.variables = {
            EDITOR = "${pkgs.neovim}/bin/nvim";
          };

          fonts = {
            packages = with pkgs; [
              proggyfonts
              noto-fonts
              nerd-fonts.caskaydia-cove
              nerd-fonts.fira-code
            ];
          };

        };
    in
    {
      # Personal computer
      darwinConfigurations."Titania" =
        let
          user = "dylan";
          unstable = nixpkgs-unstable.legacyPackages."aarch64-darwin";
          specialArgs = {
            inherit user unstable;
          };
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = specialArgs;
          modules = [
            configuration
            ./dev.nix
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
          specialArgs = {
            inherit user unstable;
          };
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = specialArgs;
          modules = [
            configuration
            ./dev.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "before-home-manager";
              home-manager.extraSpecialArgs = { inherit unstable; };
              home-manager.users.${user} = import ./home.nix;
            }
          ];
        };
    };
}
