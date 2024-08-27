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
        environment.systemPackages =
          [
            pkgs.eza
            pkgs.nmap
            pkgs.graphviz
            pkgs.du-dust
            pkgs.fswatch
            pkgs.glow
            pkgs.act
            pkgs.lazygit
            pkgs.lazydocker
            pkgs.curl
            pkgs.goose
            pkgs.delta
            pkgs.dprint
            pkgs.coreutils
            pkgs.entr
            pkgs.fd
            pkgs.git
            pkgs.gron
            pkgs.gnupg
            pkgs.go-task
            pkgs.gpg-tui
            pkgs.hledger
            pkgs.hledger-ui
            pkgs.hledger-web
            pkgs.htop
            pkgs.hugo
            pkgs.jq
            pkgs.moreutils
            pkgs.pandoc
            pkgs.pgcli
            pkgs.pgformatter
            pkgs.postgresql
            pkgs.pv
            pkgs.ranger
            pkgs.restic
            pkgs.ripgrep
            pkgs.sd
            pkgs.tig
            pkgs.tree-sitter
            pkgs.wget
            pkgs.xh
            pkgs.yq
            pkgs.zoxide
            pkgs.nushell
            pkgs.neovim
            pkgs.ast-grep
            pkgs.nodePackages.prettier
            pkgs.viddy
            pkgs.visidata
            pkgs.mise
            pkgs.cmake
            pkgs.tailspin
            pkgs.rustup
            pkgs.trufflehog
            pkgs.devenv
            pkgs.colima
            pkgs.docker
            pkgs.docker-compose
            pkgs.imagemagick
            pkgs.fx
            pkgs.darwin.trash
            pkgs.gum
            pkgs.duckdb
            pkgs.xsv
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

        # system.keyboard = {
        #   remapCapsLockToEscape = true;
        #   swapLeftCtrlAndFn = true;
        # };

        system.activationScripts = {
          neovim.text = ''
            if ! test -d ~/src/dkendal/nvim-kitty; then;
              ${pkgs.git}/bin/git clone git@github.com:Dkendal/nvim-kitty.git
            fi;

            if ! test -d ~/src/dkendal/nvim-treeclimber; then;
              ${pkgs.git}/bin/git clone git@github.com:Dkendal/nvim-treeclimber.git
            fi;
          '';

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
