{ config, pkgs, lib, inputs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  home = config.home.homeDirectory;
  configHome = config.xdg.configHome;
  dotFilesDir = "${home}/dot-files";
  gh = "git@github.com:Dkendal";
  mySrc = "${home}/src/dkendal";
  ln = config.lib.file.mkOutOfStoreSymlink;
  identityAgent =
    if isDarwin then
      "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "~/.1password/agent.sock";
in
{
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # nushell
    nushellPlugins.formats
    # highlight disabled: nu_plugin_highlight (1.4.12+0.110.0) is built against
    # nushell 0.110.0 and is incompatible with the current nushell 0.113.1.
    # Re-enable once nixpkgs bumps the plugin to match.
    # nushellPlugins.highlight
    nushellPlugins.polars
    nushellPlugins.query
    nushellPlugins.skim

    # just
    just
    just-formatter
    just-lsp
  ];

  home.activation.makeRepos =
    let
      repos = {
        "dot-files" = dotFilesDir;
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

  xdg.configFile =
    let
      list =
        [
          "expressvpn"
          "fish"
          "git"
          "kitty"
          "nix-darwin"
          "nvim"
          "jj"
        ];
    in
    builtins.listToAttrs (map
      (name: {
        inherit name;
        value.source = ln "${dotFilesDir}/xdg_config/${name}";
      })
      list);

  home.file =
    let
      list =
        [
          "nushell"
        ];
    in
    builtins.listToAttrs (map
      (name: {
        name = "Library/Application Support/${name}";
        value.source = ln "${dotFilesDir}/xdg_config/${name}";
      })
      list);


  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      editor = "${pkgs.neovim}/bin/nvim";
      git_protocol = "ssh";
    };
  };

  programs.fzf.enable = true;

  programs.nushell = {
    enable = true;
    settings = {
      buffer_editor = "nvim";
      edit_mode = "vi";
      use_kitty_protocol = true;
      highlight_resolved_externals = true;
      show_banner = false;
    };
    plugins = with pkgs.nushellPlugins; [
      formats
      # highlight disabled: incompatible nushell version (0.110.0 vs 0.113.1)
      # highlight
      polars
      query
      skim
    ];
  };

  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  programs.starship =
    {
      enable = true;
      settings = {
        git_status = {
          disabled = true;
        };
        elixir = {
          disabled = true;
        };
        nodejs = {
          disabled = true;
        };
        python = {
          disabled = true;
        };
        custom = {
          jj = {
            command = "prompt";
            format = "$output";
            ignore_timeout = true;
            shell = [ "starship-jj" "--ignore-working-copy" "starship" ];
            use_stdin = false;
            when = true;
          };
        };
      };
    };

  programs.broot = {
    enable = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.nix-index.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # matchBlocks."*".identityAgent = ''"${identityAgent}"'';
    settings."*".identityAgent = ''"${identityAgent}"'';
  };
}
