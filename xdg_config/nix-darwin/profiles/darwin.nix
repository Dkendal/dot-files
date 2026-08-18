# macOS-specific configuration: Homebrew, system defaults, TouchID,
# and other darwin-only settings.
{ pkgs, user, ... }:
{
  environment.systemPackages = [
    pkgs.darwin.trash # macOS trash utility
  ];

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "none";
      extraFlags = [ "--verbose" ];
      autoUpdate = false;
    };
    taps = [
      "noborus/tap" # trdsql
      "1password/tap"
      "lucapette/tap" # fakedata
      "localstack/tap"
    ];
    casks = [
      "1password-cli"
    ];
    brews = [
      "localstack-cli"
      "trdsql"
      "pipx"
      "wxwidgets"
      "flyctl"
      "fakedata"
      # required for elixir
      "autoconf"
      "coreutils"
      "snowflake-cli"
    ];
  };

  # Match the determinate installer ids
  ids.gids.nixbld = 350;

  nix.gc = {
    automatic = true;
    interval.Day = 7; #Hours, minutes
    options = "--delete-older-than 7d";
  };

  users.users.${user}.home = "/Users/${user}";

  security.pam.services.sudo_local.touchIdAuth = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = user;

  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
    };

    dock = {
      mru-spaces = false;
      show-recents = false;
    };

    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
  };

  system.stateVersion = 7;
}
