#!/bin/sh
set -eux
rm -rf \
  "${HOME:?}"/* \
  "${HOME:?}"/.[!.]* \
  "${HOME:?}"/..?* \
  "${GITHUB_WORKSPACE:?}"/* \
  "${GITHUB_WORKSPACE:?}"/.[!.]* \
  "${GITHUB_WORKSPACE:?}"/..?*
docker ps -aq | grep -v "$(cat /etc/hostname)" | xargs docker rm -f
