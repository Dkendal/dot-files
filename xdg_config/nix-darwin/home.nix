{ config, pkgs, lib, ... }:
let
  ln = pkgs.lib.file.mkOutOfStoreSymlink;
  homeDir = config.home.homeDirectory;
  dotFilesDir = "${homeDir}/dot-files";
  gh = "git@github.com:Dkendal";
  mySrc = "${homeDir}/src/dkendal";
in
{
  home.stateVersion = "24.05";

  home.activation = {
    makeRepos = lib.hm.dag.entryAfter [ "installPackages" ] ''
      mkdir -p ${homeDir}/src

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
    '';
  };

  xdg.enable = true;

  # Symlink non home-manager config files
  xdg.configFile = builtins.listToAttrs (map
    (name: {
      inherit name;
      value.source = config.lib.file.mkOutOfStoreSymlink "${dotFilesDir}/xdg_config/${name}";
    })
    [
      "kitty"
      "fish"
      "nvim"
      "expressvpn"
      "git"
      "nix-darwin"
      "nushell/login.nu"
    ]
  );

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
    # configFile = {
    #   text = "
    #     $env.config = {
    #       show_banner: false
    #       edit_mode: vi
    #       use_kitty_protocol: true
    #       highlight_resolved_externals: true
    #     }
    #   ";
    # };
  };

  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    globalConfig = {
      tools = {
        node = "lts";
        usage = "0.3";
        erlang = "27";
        elixir = "1";
        lua = "5.1";
        go = "1";
      };
    };
  };

  programs.starship = {
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
      # custom.jj = {
      #   command = ''
      #   jj log -r@ -n1 --ignore-working-copy --no-graph --color always  -T '
      #     separate(" ",
      #       bookmarks.map(|x| if(
      #           x.name().substr(0, 10).starts_with(x.name()),
      #           x.name().substr(0, 10),
      #           x.name().substr(0, 9) ++ "…")
      #         ).join(" "),
      #       tags.map(|x| if(
      #           x.name().substr(0, 10).starts_with(x.name()),
      #           x.name().substr(0, 10),
      #           x.name().substr(0, 9) ++ "…")
      #         ).join(" "),
      #       surround("\"","\"",
      #         if(
      #            description.first_line().substr(0, 24).starts_with(description.first_line()),
      #            description.first_line().substr(0, 24),
      #            description.first_line().substr(0, 23) ++ "…"
      #         )
      #       ),
      #       if(conflict, "conflict"),
      #       if(divergent, "divergent"),
      #       if(hidden, "hidden"),
      #     )
      #   '
      #   '';
      #   when = "jj root";
      #   symbol = "🐦‍⬛";
      # };
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

