# Development tooling: version control, build systems, containers,
# language tooling, language servers, and code quality tools.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;
    [
      # Development Tools
      git # Distributed version control system
      git-absorb # Git command for automatically absorbing staged changes into commits
      lazygit # Simple terminal UI for git commands
      jjui
      jujutsu # Distributed version control system (alternative to Git)
      tig # Text-mode interface for Git
      delta # Syntax-highlighting pager for git, diff outputs
      patchutils # Collection of programs for manipulating patch files
      mergiraf
      meld

      # Build Systems & Compilation
      cmake # Cross-platform build system generator
      devenv # Developer environments
      scons
      act # Run GitHub Actions locally
      go-task # Task runner / simpler Make alternative

      # Containers & Virtualization
      docker # Platform for developing, shipping, and running applications
      docker-compose # Tool for defining and running multi-container Docker applications
      colima # Container runtimes on macOS
      lazydocker # Terminal UI for Docker

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
      fnlfmt # Formatter for Fennel Lisp dialect

      # Programming Languages & Environment Management
      uv # Python packaging and virtual environment manager
      mise # Development environment manager (formerly rtx)
      usage
      rustup
      cargo-binstall
      cargo-expand
      lean4
      tlaplus

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
      marksman

      # Editors
      neovim # Hyperextensible Vim-based text editor

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
    ];
}
