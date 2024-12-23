{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-stable, home-manager, ... }:
    let
      overlay = find: prev: {
        go-task = nixpkgs-stable.legacyPackages.${prev.system}.go-task;
      };
      configuration = { pkgs, user, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs;
          [
            act
            ast-grep
            cmake
            colima
            coreutils
            curl
            darwin.trash
            delta
            devenv
            docker
            docker-compose
            dprint
            du-dust
            duckdb
            entr
            eza
            fd
            fennel-ls
            fnlfmt
            fswatch
            fx
            git
            git-absorb
            glow
            gnupg
            go-task
            goose
            gpg-tui
            graphviz
            gron
            gum
            hledger
            hledger-ui
            hledger-web
            htop
            hugo
            imagemagick
            jq
            jujutsu
            lazydocker
            lazygit
            luajitPackages.fennel
            luajitPackages.teal-language-server
            luajitPackages.tl
            mise
            moreutils
            neovim
            nodePackages.prettier
            nushell
            ollama
            oterm
            pandoc
            pgcli
            pgformatter
            postgresql
            pv
            ranger
            rclone
            restic
            ripgrep
            rustup
            sapling
            sd
            tailspin
            tig
            tree-sitter
            trufflehog
            uutils-coreutils-noprefix
            uv
            viddy
            visidata
            wget
            xh
            xsv
            yq
            zoxide
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
            "linearmouse"
            "mitmproxy"
            "ghostty"
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
        nix.settings.trusted-users = [ "root" user ];

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

        environment.shells = [ pkgs.fish "/usr/local/bin/fish" ];

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
