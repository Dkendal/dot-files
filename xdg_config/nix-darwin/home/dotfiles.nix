{ config, pkgs, lib, ... }:
let
  home = config.home.homeDirectory;
  root = "${home}/dot-files";
  gh = "git@github.com:Dkendal";
  mySrc = "${home}/src/dkendal";
  ln = path: config.lib.file.mkOutOfStoreSymlink "${root}/${path}";
in
{
  home.activation.makeRepos =
    let
      repos = {
        "dot-files" = root;
        "newtype" = "${mySrc}/newtype";
        "nvim-treeclimber" = "${mySrc}/nvim-treeclimber";
        "nvim-kitty" = "${mySrc}/nvim-kitty";
        "nvim-alternate" = "${mySrc}/nvim-alternate";
        "nvim-coverage" = "${mySrc}/nvim-coverage";
      };
      cloneRepo = name: path: ''
        if [ ! -d "${path}" ]; then
          echo "Cloning ${name}"
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone $VERBOSE_ARG "${gh}/${name}.git" "${path}"
        fi
      '';
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p "${mySrc}"
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList cloneRepo repos)}
    '';

  xdg.enable = true;

  xdg.configFile = {
    "fish".source = ln "xdg_config/fish";
    "nvim".source = ln "xdg_config/nvim";
    "jj".source = ln "xdg_config/jj";
    "nix-darwin".source = ln "xdg_config/nix-darwin";
    "kitty".source = ln "xdg_config/kitty";
    "git".source = ln "xdg_config/git";
    "mise".source = ln "xdg_config/mise";
  };


  home.file = {
    "Library/Application Support/nushell".source =
      ln "xdg_config/nushell";

    ".pi/agent/models.json".source =
      ln "xdg_config/nix-darwin/home/dotfiles/pi-models.json";

    ".claude/output-styles/eli5.md".source =
      ln "xdg_config/nix-darwin/home/dotfiles/claude-output-styles-eli5.md";

    ".claude/output-styles/ste.md".source =
      ln "xdg_config/nix-darwin/home/dotfiles/claude-output-styles-ste.md";
  };
}
