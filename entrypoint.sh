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
length=$(printf '%s' "$containers" | wc -l)
self=$(cat /etc/hostname)
if test "$length" -gt 1; then
  printf '%s' "$containers" | grep --fixed-strings --invert-match "$self" | xargs docker rm --force
fi
