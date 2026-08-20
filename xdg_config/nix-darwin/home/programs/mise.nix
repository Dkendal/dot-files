{ pkgs, ... }:
{
  programs.mise =
    {
      enable = true;
      package = pkgs.mise;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };
}
