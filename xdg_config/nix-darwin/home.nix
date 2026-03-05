{ config, pkgs, lib, unstable, ... }:
let
  home = config.home.homeDirectory;
  configHome = config.xdg.configHome;
  dotFilesDir = "${home}/dot-files";
  gh = "git@github.com:Dkendal";
  mySrc = "${home}/src/dkendal";
  ln = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # just
    just
    just-formatter
    just-lsp
  ];

  home.activation.makeRepos = lib.hm.dag.entryAfter [ "installPackages" ] ''
    mkdir -p ${home}/src

    clone_repo() {
      local repo_name=$1
      local repo_path=$2
      if [ ! -d "$repo_path" ]; then
        echo "Cloning $repo_name"
        ${pkgs.git}/bin/git clone "$repo_name" "$repo_path"
      else
        echo "Skipping $repo_name: already cloned"
      fi
    }

    clone_repo "${gh}/dot-files.git" "${dotFilesDir}"
    clone_repo "${gh}/newtype.git" "${mySrc}/newtype"
    clone_repo "${gh}/nvim-treeclimber.git" "${mySrc}/nvim-treeclimber"
    clone_repo "${gh}/nvim-kitty.git" "${mySrc}/nvim-kitty"
    clone_repo "${gh}/nvim-alternate.git" "${mySrc}/nvim-alternate"
    clone_repo "${gh}/nvim-coverage.git" "${mySrc}/nvim-coverage"
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
    package = pkgs.nushell;
    settings = {
      buffer_editor = "nvim";
      edit_mode = "vi";
      use_kitty_protocol = true;
      highlight_resolved_externals = true;
      show_banner = false;
    };
    plugins = with pkgs.nushellPlugins; [
      formats
      highlight
      polars
      query
      skim
    ];
  };

  programs.mise = {
    enable = true;
    package = unstable.mise;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    globalConfig = {
      tools = {
        node = "lts";
        usage = "0.3";
        erlang = "27";
        elixir = "1";
        lua = "5.1";
        go = "1";
        watchexec = "2.5";
      };
    };
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
}
