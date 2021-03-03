#!/bin/sh
set -eux
rm -rf \
  "${HOME:?}"/* \
  "${HOME:?}"/.[!.]* \
  "${HOME:?}"/..?* \
  "${GITHUB_WORKSPACE:?}"/* \
  "${GITHUB_WORKSPACE:?}"/.[!.]* \
  "${GITHUB_WORKSPACE:?}"/..?*
containers=$(docker ps --all --quiet)
self=$(cat /etc/hostname)
if test "$containers" != "$self"; then
  printf '%s' "$containers" | grep --fixed-strings --invert-match "$self" | xargs docker rm --force
fi
