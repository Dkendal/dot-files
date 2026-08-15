{ pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  identityAgent =
    if isDarwin then
      "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "~/.1password/agent.sock";
in
{
  imports = [
    ./modules/tree-sitter-parsers.nix
    ./home/dotfiles.nix
    ./home/programs/mise.nix
    ./home/programs/treesitter-parsers.nix
  ];

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    nushellPlugins.formats
    nushellPlugins.polars
    nushellPlugins.query
    nushellPlugins.skim
    just
    just-formatter
    just-lsp
  ];

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
      # highlight disabled: incompatible nushell version (0.110.0 vs 0.113.1)
      # highlight
      polars
      query
      skim
    ];
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
    settings."*".identityAgent = ''"${identityAgent}"'';
  };
}
