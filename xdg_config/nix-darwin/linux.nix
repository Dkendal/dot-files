# Linux (NixOS)-specific configuration: counterparts to the
# darwin-only settings in darwin.nix.
{ user, ... }:
{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "26.05";
}
