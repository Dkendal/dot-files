# Only execute this file once per shell.
if [ -n "$__ETC_PROFILE_NIX_SOURCED" ]
  exit 0
end

set -x __ETC_PROFILE_NIX_SOURCED 1

set -x NIX_USER_PROFILE_DIR "/nix/var/nix/profiles/per-user/$USER"
set -x NIX_PROFILES "/nix/var/nix/profiles/default $HOME/.nix-profile"

# set -x $NIX_SSL_CERT_FILE so that Nixpkgs applications like curl work.
if [ ! -z "$NIX_SSL_CERT_FILE" ]
  exit 0 # Allow users to override the NIX_SSL_CERT_FILE
else if [ -e /etc/ssl/certs/ca-certificates.crt ] # NixOS, Ubuntu, Debian, Gentoo, Arch
  set -x NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
else if [ -e /etc/ssl/ca-bundle.pem ] # openSUSE Tumbleweed
  set -x NIX_SSL_CERT_FILE /etc/ssl/ca-bundle.pem
else if [ -e /etc/ssl/certs/ca-bundle.crt ] # Old NixOS
  set -x NIX_SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt
else if [ -e /etc/pki/tls/certs/ca-bundle.crt ] # Fedora, CentOS
  set -x NIX_SSL_CERT_FILE /etc/pki/tls/certs/ca-bundle.crt
else
  # Fall back to what is in the nix profiles, favouring whatever is defined last.
  for i in $NIX_PROFILES
    if [ -e $i/etc/ssl/certs/ca-bundle.crt ]
      set -x NIX_SSL_CERT_FILE $i/etc/ssl/certs/ca-bundle.crt
    end
  end
end

set -x NIX_PATH "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixpkgs:/nix/var/nix/profiles/per-user/root/channels"

if test -d "/nix"
  set -x fish_user_paths \
    "$HOME/.nix-profile/bin" \
    "/nix/var/nix/profiles/default/bin" \
    $fish_user_paths
end
