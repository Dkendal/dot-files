# Development tooling: version control, build systems, containers,
# language tooling, language servers, and code quality tools.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;
    [
      kitty
      ast-grep
      bash-language-server
      cargo-binstall
      cargo-expand
      cmake
      codespell
      colima
      delta
      devenv
      docker
      docker-compose
      dprint
      emmet-ls
      fennel-ls
      fnlfmt
      git
      git-absorb
      gnuplot
      go-task
      imagemagick
      jjui
      jujutsu
      lazydocker
      lazygit
      lean4
      lua-language-server
      marksman
      meld
      mergiraf
      nil
      nixpkgs-fmt
      ollama
      patchutils
      pgformatter
      postgresql
      putty
      pv
      rustup
      scons
      shellcheck
      shellharden
      stylua
      tailwindcss-language-server
      taplo
      tig
      timg
      tinymist
      tlaplus
      tlaplus18
      tmux
      neovim
      usage
      uv
      xh

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
