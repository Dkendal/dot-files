# Portable settings shared by all hosts (darwin or linux):
# base packages, nix settings, shells, and fonts.
{ pkgs, user, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [
      # Core System Utilities
      uutils-coreutils-noprefix # Rust implementation of GNU coreutils
      curl # Command line tool for transferring data with URL syntax
      wget # Non-interactive network downloader

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
      nufmt
      htop # Interactive process viewer
      gum # Tool for glamorous shell scripts
      viddy # Modern watch command (executes command periodically)
      hyperfine # Command-line benchmarking tool

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

      # Text & Document Processing
      pandoc # Universal document converter
      glow # Markdown renderer for the terminal

      # Security Tools
      gnupg # GNU Privacy Guard - encryption and signing tool
      gpg-tui # Terminal user interface for GnuPG
      trufflehog # Secret detection in git repositories or files
      gitleaks # Fast secret scanner (regex + entropy) for the pre-push hook

      # Monitoring & Logging
      entr # Run arbitrary commands when files change
      fswatch # File change monitor
      tailspin # Log file highlighter
      lnav # Log file navigator

      # Data Visualization & Diagramming
      d2 # Diagram scripting language
      graphviz # Graph visualization software
    ];

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

  nix.settings.auto-optimise-store = true;
  nix.settings.download-buffer-size = 500000000; # 500MB

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  programs.bash.enable = true;
  programs.fish.enable = true;

  users.users.${user}.shell = pkgs.fish;

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
}
