{ pkgs, ... }:
{
  programs.mise =
    {
      enable = true;
      package = pkgs.mise;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      globalConfig = {
        tools = {
          "github:can1357/oh-my-pi" = "17.3.4";
          bun = "1.3.14";
          elixir = "1.20.3";
          erlang = "27.3.4.2";
          gh = "2.97.0";
          go = "1.26.5";
          jj = "0.44.0";
          lua = "5.1";
          node = "26.7.0";
          opencode = "1.18.18";
          pi = "0.84.2";
          usage = "0.3";
          uv = "0.12.5";
          watchexec = "2.5";
        };
      };
    };
}
