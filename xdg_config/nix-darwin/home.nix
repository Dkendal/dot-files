{ config, pkgs, ... }:
{
  home.stateVersion = "24.05";

  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
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
    configFile = {
      text = "
        $env.config = {
          show_banner: false
          edit_mode: vi
          use_kitty_protocol: true
          highlight_resolved_externals: true
        }
      ";
    };
  };

  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        node = "lts";
        usage = "0.3";
        erlang = "27.0";
        elixir = "1.17";
        lua = "5.1";
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
    };
  };

  programs.nix-index.enable = true;
}
