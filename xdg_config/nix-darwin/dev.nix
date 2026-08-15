# Development tooling: version control, build systems, containers,
# language tooling, language servers, and code quality tools.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;
    [
      ast-grep # CLI tool for structural search and replace of code
      bash-language-server # Bash Language Server
      cargo-binstall
      cargo-expand
      cmake # Cross-platform build system generator
      codespell # Check code for common misspellings
      colima # Container runtimes on macOS
      delta # Syntax-highlighting pager for git, diff outputs
      devenv # Developer environments
      docker # Platform for developing, shipping, and running applications
      docker-compose # Tool for defining and running multi-container Docker applications
      dprint # Pluggable and configurable code formatting platform
      emmet-ls # Emmet support for Language Servers
      fennel-ls # Fennel language server
      fnlfmt # Formatter for Fennel Lisp dialect
      git # Distributed version control system
      git-absorb # Git command for automatically absorbing staged changes into commits
      gnuplot
      go-task # Task runner / simpler Make alternative
      imagemagick # Create, edit, compose, or convert bitmap images
      jjui
      jujutsu # Distributed version control system (alternative to Git)
      lazydocker # Terminal UI for Docker
      lazygit # Simple terminal UI for git commands
      lean4
      lua-language-server # Language Server for Lua
      marksman
      meld
      mergiraf
      mise # Development environment manager (formerly rtx)
      nil # Nix language server
      nixpkgs-fmt
      nodePackages.vega-cli
      nodePackages.vega-lite
      ollama
      patchutils # Collection of programs for manipulating patch files
      pgformatter # PostgreSQL SQL syntax beautifier
      postgresql
      putty
      pv # Monitor the progress of data through a pipeline
      roslyn-ls
      rustup
      scons
      shellcheck
      shellharden
      stylua # Opinionated Lua code formatter
      tailwindcss-language-server # Tailwind CSS Language Server
      taplo # TOML Language Server
      tig # Text-mode interface for Git
      timg
      tinymist # Typst language server
      tlaplus
      tlaplus18
      tmux
      unstable.neovim
      usage
      uv # Python packaging and virtual environment manager
      xh # Friendly and fast tool for sending HTTP requests

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
    ];
}
