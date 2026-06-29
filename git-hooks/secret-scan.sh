#!/usr/bin/env bash
#
# Secret scanner for the dot-files repo.
# Runs gitleaks (broad regex/entropy net) + trufflehog (verified live keys)
# over the git history. Shared by the pre-push hook and `task check`.
#
# Exit non-zero if either tool reports a finding, so callers can block on it.

set -uo pipefail

repo_root="$(git rev-parse --show-toplevel)" || exit 1
cd "$repo_root" || exit 1

status=0

run_gitleaks() {
  if ! command -v gitleaks >/dev/null 2>&1; then
    printf '   gitleaks not on PATH — skipping (run `task switch` to install).\n' >&2
    return 0
  fi
  printf '==> gitleaks: scanning commit history…\n'
  # `git` is the modern subcommand; older builds used `detect`.
  gitleaks git --redact --no-banner .
  local rc=$?
  if [ "$rc" -gt 1 ]; then
    # Unknown subcommand / usage error on older gitleaks → fall back.
    gitleaks detect --redact --no-banner --source .
    rc=$?
  fi
  return "$rc"
}

run_trufflehog() {
  if ! command -v trufflehog >/dev/null 2>&1; then
    printf '   trufflehog not on PATH — skipping.\n' >&2
    return 0
  fi
  printf '==> trufflehog: scanning commit history (verified secrets only)…\n'
  # NB: the nixpkgs trufflehog wrapper already injects --no-update; don't repeat it.
  trufflehog git "file://$repo_root" --only-verified --fail
}

run_gitleaks || status=1
run_trufflehog || status=1

if [ "$status" -ne 0 ]; then
  printf '\n🔒 Secret scan FAILED — potential secrets detected above.\n' >&2
  printf '   If a match is a false positive, allowlist it in .gitleaks.toml.\n' >&2
else
  printf '✅ Secret scan clean.\n'
fi

exit "$status"
