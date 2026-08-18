{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;
    [
      roslyn-ls
    ];
}
