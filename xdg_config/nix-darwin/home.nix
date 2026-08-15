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
  imports = [ ./modules/tree-sitter-parsers.nix ];

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
          "jj/config.toml"
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


  programs.treesitter-parsers = {
    enable = true;
    parsers = {
      luadoc = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-luadoc";
        ref = "873612aadd3f684dd4e631bdf42ea8990c57634e";
        hash = "sha256-ttGBB9sn+xd9jWzjNAzpo/lwYVYZGSUGEip4K3PfBP0=";
      };
      csv = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-csv";
        ref = "f6bf6e35eb0b95fbadea4bb39cb9709507fcb181";
        hash = "sha256-9mW0kT4av/ULFqLXdMuyLrMPtQxrIOKY60GQ4QDB33o=";
        location = "csv";
      };
      vim = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-vim";
        ref = "3092fcd99eb87bbd0fc434aa03650ba58bd5b43b";
        hash = "sha256-MnLBFuJCJbetcS07fG5fkCwHtf/EcNP+Syf0Gn0K39c=";
      };
      query = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-query";
        ref = "15e00db655cf1708cf8e4b172b2f321d9b7b98c1";
        hash = "sha256-gZangrC4Nn6JLz9kY7WXYRiKtRowtlvUD6+pDP8HTzM=";
      };
      diff = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-diff";
        ref = "2520c3f934b3179bb540d23e0ef45f75304b5fed";
        hash = "sha256-8rYLNGgoZSvvfqO2++nAgFKmvbkKJ3m+9B8bTXp6Us4=";
      };
      haskell = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-haskell";
        ref = "98aedbd2d6947a168ba3ba3755d70b0cb6b78395";
        hash = "sha256-eunizglx3nye3LZIAndBX/hf0BvFOWmThQwxvvjqcfU=";
      };
      markdown = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown";
        ref = "c3570720f7f7bbad22fe96603f106276618e0cf5";
        hash = "sha256-wQKcqU0V6gHj84qOkUwdXsBW3f6MNfJMFxuGTucAgh8=";
        location = "tree-sitter-markdown";
      };
      markdown-inline = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown";
        ref = "c3570720f7f7bbad22fe96603f106276618e0cf5";
        hash = "sha256-wQKcqU0V6gHj84qOkUwdXsBW3f6MNfJMFxuGTucAgh8=";
        location = "tree-sitter-markdown-inline";
        language = "markdown_inline";
      };
      typescript = {
        url = "https://github.com/tree-sitter/tree-sitter-typescript";
        ref = "75b3874edb2dc714fb1fd77a32013d0f8699989f";
        hash = "sha256-A0M6IBoY87ekSV4DfGHDU5zzFWdLjGqSyVr6VENgA+s=";
        location = "typescript";
      };
      tsx = {
        url = "https://github.com/tree-sitter/tree-sitter-typescript";
        ref = "75b3874edb2dc714fb1fd77a32013d0f8699989f";
        hash = "sha256-A0M6IBoY87ekSV4DfGHDU5zzFWdLjGqSyVr6VENgA+s=";
        location = "tsx";
      };
      lua = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-lua";
        ref = "10fe0054734eec83049514ea2e718b2a56acd0c9";
        hash = "sha256-VzaaN5pj7jMAb/u1fyyH6XmLI+yJpsTlkwpLReTlFNY=";
      };
      rust = {
        url = "https://github.com/tree-sitter/tree-sitter-rust";
        ref = "77a3747266f4d621d0757825e6b11edcbf991ca5";
        hash = "sha256-Ls6tB6IxXDQDWwx0BJ7RgbheelC4MH8z97E7wwhkDcY=";
      };
      toml = {
        url = "https://github.com/tree-sitter/tree-sitter-toml";
        ref = "64b56832c2cffe41758f28e05c756a3a98d16f41";
        hash = "sha256-m9RlGkHiOL/PNENrdEPqtPlahSqGymsx7gZrCoN/Lsk=";
      };
      c_sharp = {
        url = "https://github.com/tree-sitter/tree-sitter-c-sharp";
        ref = "af29416d729b7a6603101b513604392d8f675e3b";
        hash = "sha256-3iTkgG4eitny4VHI+IwJaVvkVKN/PzotYXFCWbJ4TPU=";
      };
    };
  };

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
