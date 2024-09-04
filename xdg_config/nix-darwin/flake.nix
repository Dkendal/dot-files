{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
    let
      configuration = { pkgs, user, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs;
          [
            eza
            nmap
            graphviz
            du-dust
            fswatch
            glow
            act
            lazygit
            lazydocker
            curl
            goose
            delta
            dprint
            coreutils
            entr
            fd
            git
            gron
            gnupg
            go-task
            gpg-tui
            hledger
            hledger-ui
            hledger-web
            htop
            hugo
            jq
            moreutils
            pandoc
            pgcli
            pgformatter
            postgresql
            pv
            ranger
            restic
            ripgrep
            sd
            tig
            tree-sitter
            wget
            xh
            yq
            zoxide
            nushell
            neovim
            ast-grep
            nodePackages.prettier
            viddy
            visidata
            mise
            cmake
            tailspin
            rustup
            trufflehog
            devenv
            colima
            docker
            docker-compose
            imagemagick
            fx
            darwin.trash
            gum
            duckdb
            xsv
            ollama
          ];

        homebrew = {
          enable = true;
          onActivation = {
            cleanup = "zap";
            extraFlags = [ "--verbose" ];
            autoUpdate = true;
          };
          taps = [
            "noborus/tap"
            "1password/tap"
          ];
          casks = [
            "1password-cli"
            "alt-tab"
            "font-caskaydia-cove-nerd-font"
            "linearmouse"
            "mitmproxy"
          ];
          brews = [
            "trdsql"
            "pipx"
            "wxwidgets"
            "flyctl"
            "autoconf"
            "openssl@1.1" # required for elixir
          ];
          masApps = {
            Tailscale = 1475387142;
          };
        };

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;

        services.tailscale.enable = true;

        security.pam.enableSudoTouchIdAuth = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        nix.gc = {
          automatic = true;
          interval.Day = 7; #Hours, minutes
          options = "--delete-older-than 7d";
        };

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        programs.zsh.enable = true;
        programs.bash.enable = true;
        programs.fish.enable = true;

        users.users.${user} = {
          home = "/Users/${user}";
          shell = pkgs.fish;
        };

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

        system.activationScripts = {
          rustup.text = ''
            ${pkgs.rustup}/bin/rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
          '';

          postUserActivation.text = ''
            # Reloads defaults
            /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
          '';
        };

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        environment.shells = [ pkgs.fish ];

        environment.variables = {
          EDITOR = "${pkgs.neovim}/bin/nvim";
        };

        fonts = {
          fontDir.enable = true;
          fonts = with pkgs; [
            proggyfonts
            noto-fonts
            (nerdfonts.override {
              fonts = [
                "CascadiaCode"
                "FiraCode"
              ];
            })
          ];
        };

      };
    in
    {
      # Personal computer
      darwinConfigurations."Titania" =
        let
          user = "dylan";
          specialArgs = {
            user = user;
          };
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = specialArgs;
          modules = [
            configuration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "before-home-manager";
              home-manager.users.${user} = import ./home.nix;
            }
          ];
        };

      # Work computer
      darwinConfigurations."dylankendal-mbp" =
        let
          user = "dylan.kendal";
          specialArgs = {
            user = user;
          };
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = specialArgs;
          modules = [
            configuration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "before-home-manager";
              home-manager.users.${user} = import ./home.nix;
            }
          ];
        };
    };
}
