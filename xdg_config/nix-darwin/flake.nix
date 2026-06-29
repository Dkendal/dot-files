{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      overlay = final: prev: {
        # neovim = inputs.neovim-nightly-overlay.packages.${prev.system}.default;
        fzf = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.fzf;
      };
      configuration = { pkgs, user, ... }:
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

              # Development Tools
              git # Distributed version control system
              git-absorb # Git command for automatically absorbing staged changes into commits
              lazygit # Simple terminal UI for git commands
              lazyjj
              jujutsu # Distributed version control system (alternative to Git)
              tig # Text-mode interface for Git
              delta # Syntax-highlighting pager for git, diff outputs
              patchutils # Collection of programs for manipulating patch files

              # Build Systems & Compilation
              cmake # Cross-platform build system generator
              devenv # Developer environments

              # Containers & Virtualization
              docker # Platform for developing, shipping, and running applications
              docker-compose # Tool for defining and running multi-container Docker applications
              colima # Container runtimes on macOS
              lazydocker # Terminal UI for Docker

              # Data Processing & Analysis
              jq # Lightweight and flexible command-line JSON processor
              yq # YAML/XML/TOML processor (similar to jq)
              gron # Make JSON greppable by flattening it
              duckdb # In-process SQL OLAP database management system
              visidata # Terminal spreadsheet multitool for data discovery and arrangement
              xan # Text analyzer and processor
              fx # Command-line JSON processing tool
              ripgrep # Fast line-oriented search tool (grep alternative)
              sd # Intuitive find & replace CLI tool

              # Database Tools
              postgresql
              pgformatter # PostgreSQL SQL syntax beautifier

              # Code Quality & Formatting
              dprint # Pluggable and configurable code formatting platform
              ast-grep # CLI tool for structural search and replace of code
              codespell # Check code for common misspellings
              stylua # Opinionated Lua code formatter
              shellharden
              shellcheck

              # Programming Languages & Environment Management
              uv # Python packaging and virtual environment manager
              mise # Development environment manager (formerly rtx)
              rustup

              # Language Servers (for IDE-like features)
              nil # Nix language server
              efm-langserver # General purpose Language Server
              lua-language-server # Language Server for Lua
              emmet-ls # Emmet support for Language Servers
              tailwindcss-language-server # Tailwind CSS Language Server
              bash-language-server # Bash Language Server
              taplo # TOML Language Server
              fennel-ls # Fennel language server
              beamPackages.expert
              luajitPackages.fennel # Lisp that compiles to Lua
              luajitPackages.teal-language-server # Teal language server
              luajitPackages.tl # Teal language compiler/type checker
              nixpkgs-fmt
              tinymist # Typst language server

              # Text & Document Processing
              pandoc # Universal document converter
              glow # Markdown renderer for the terminal
              fnlfmt # Formatter for Fennel Lisp dialect

              # Security Tools
              gnupg # GNU Privacy Guard - encryption and signing tool
              gpg-tui # Terminal user interface for GnuPG
              trufflehog # Secret detection in git repositories or files

              # Monitoring & Logging
              entr # Run arbitrary commands when files change
              fswatch # File change monitor
              tailspin # Log file highlighter
              lnav # Log file navigator

              # Data Visualization & Diagramming
              d2 # Diagram scripting language
              graphviz # Graph visualization software

              # Work & Productivity
              jira-cli-go # Command line interface for Jira
              act # Run GitHub Actions locally
              go-task # Task runner / simpler Make alternative
              usage

              cargo-binstall
              cargo-expand
              mergiraf
              meld

              # Custom Rust crates
              (pkgs.rustPlatform.buildRustPackage rec {
                pname = "starship-jj";
                version = "0.6.0";
                src = pkgs.fetchCrate {
                  inherit pname version;
                  sha256 = "sha256-oJNww2zuof/fngb5q7+NoguebLv+urjqPV74dkBLFFk=";
                };
                cargoHash = "sha256-E5z3AZhD3kiP6ojthcPne0f29SbY0eV4EYTFewA+jNc=";
              })

              (pkgs.rustPlatform.buildRustPackage rec {
                pname = "fake";
                version = "4.4.0";
                src = pkgs.fetchCrate {
                  inherit pname version;
                  sha256 = "sha256-mYswgFDX3GVfxOPSdbDj7SCwIsY6BNxI8I/WcvHMscs=";
                };
                cargoHash = "sha256-BcHakzBj3xZ/yTTaI6umW3H2gxXAFdOBymcnRCPdnDU=";
                doCheck = false;
                buildType = "release";
              })

              # Media Processing
              imagemagick # Create, edit, compose, or convert bitmap images
              luajitPackages.magick

              # HTTP Tools
              xh # Friendly and fast tool for sending HTTP requests

              # Editors
              neovim # Hyperextensible Vim-based text editor

              # Utilities Not Easily Categorized
              pv # Monitor the progress of data through a pipeline          ];

              ollama

              marksman

              devenv
              gnuplot
              timg
              lean4
              scons
              tlaplus
            ];

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
              "lucapette/tap" # fakedata
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
              "fakedata"
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

          # services.tailscale.enable = true;

          programs.zsh.enable = true;
          programs.bash.enable = true;
          programs.fish.enable = true;

          users.users.${user} = {
            home = "/Users/${user}";
            shell = pkgs.fish;
          };

          # users.users.claude = {
          #   createHome = false;
          # };
          #
          # users.groups.ai_agents = {
          # };

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
