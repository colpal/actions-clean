#!/bin/sh
set -eux
rm -rf \
  "${HOME:?}" \
  "${GITHUB_WORKSPACE:?}"/* \
  "${GITHUB_WORKSPACE:?}"/.[!.]* \
  "${GITHUB_WORKSPACE:?}"/..?*
