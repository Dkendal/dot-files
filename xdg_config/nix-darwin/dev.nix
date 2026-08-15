{ pkgs, unstable, ... }:
{
  environment.systemPackages = with pkgs;
    [
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
      xmlstarlet
      dasel

      # Database Tools
      postgresql
      pgformatter # PostgreSQL SQL syntax beautifier
      pgcli

      # Code Quality & Formatting
      dprint # Pluggable and configurable code formatting platform
      nodePackages.prettier # Code formatter for JavaScript, CSS, JSON, etc.
      ast-grep # CLI tool for structural search and replace of code
      codespell # Check code for common misspellings
      stylua # Opinionated Lua code formatter
      shellharden
      shellcheck

      # Programming Languages & Environment Management
      rustup # Rust toolchain installer
      uv # Python packaging and virtual environment manager
      pyenv
      unstable.mise # Development environment manager (formerly rtx)

      # Language Servers (for IDE-like features)
      nil # Nix language server
      efm-langserver # General purpose Language Server
      lua-language-server # Language Server for Lua
      emmet-ls # Emmet support for Language Servers
      tailwindcss-language-server # Tailwind CSS Language Server
      bash-language-server # Bash Language Server
      taplo # TOML Language Server
      fennel-ls # Fennel language server
      lexical # elixir language server
      luajitPackages.fennel # Lisp that compiles to Lua
      luajitPackages.teal-language-server # Teal language server
      luajitPackages.tl # Teal language compiler/type checker
      nixpkgs-fmt
      tinymist # Typst language server

      # Text & Document Processing
      pandoc # Universal document converter
      glow # Markdown renderer for the terminal
      fnlfmt # Formatter for Fennel Lisp dialect

      # Data Visualization & Diagramming
      d2 # Diagram scripting language
      graphviz # Graph visualization software

      # Accounting & Finance
      hledger # Plain text accounting tool
      hledger-ui # Terminal UI for hledger
      hledger-web # Web interface for hledger
      hledger-utils

      # Work & Productivity
      jira-cli-go # Command line interface for Jira
      act # Run GitHub Actions locally
      go-task # Task runner / simpler Make alternative

      cargo-binstall
      cargo-expand
      mergiraf
      typst

      python312
      python312Packages.matplotlib
      python312Packages.seaborn
      python312Packages.faker

      jjui
      typstyle

      # Custom Rust crates
      (unstable.rustPlatform.buildRustPackage rec {
        pname = "starship-jj";
        version = "0.7.0";
        src = unstable.fetchCrate {
          inherit pname version;
          sha256 = "sha256-oisz3V3UDHvmvbA7+t5j7waN9NykMUWGOpEB5EkmYew=";
        };
        cargoHash = "sha256-NNeovW27YSK/fO2DjAsJqBvebd43usCw7ni47cgTth8=";
      })

      (pkgs.rustPlatform.buildRustPackage rec {
        pname = "fake";
        version = "4.4.0";
        src = pkgs.fetchCrate {
          inherit pname version;
          sha256 = "sha256-mYswgFDX3GVfxOPSdbDj7SCwIsY6BNxI8I/WcvHMscs=";
        };
        # Use importCargoLock (fetchurl, like fetchCrate above) instead of
        # cargoHash/fetchCargoVendor. The latter fetches via python-requests,
        # whose default User-Agent crates.io now blocks with HTTP 403.
        cargoLock.lockFile = ./pkgs/fake-Cargo.lock;
        # The `fake` binary is gated behind the `cli` feature.
        buildFeatures = [ "cli" ];
        doCheck = false;
        buildType = "release";
      })

      # Media Processing
      imagemagick # Create, edit, compose, or convert bitmap images
      luajitPackages.magick

      # HTTP Tools
      xh # Friendly and fast tool for sending HTTP requests

      # Editors
      unstable.neovim

      # Utilities Not Easily Categorized
      pv # Monitor the progress of data through a pipeline

      ollama
      putty
      gnuplot
      nodePackages.vega-cli
      nodePackages.vega-lite
      timg
      tlaplus18
    ];
}
