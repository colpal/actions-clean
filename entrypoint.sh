#!/bin/sh
set -eux
rm -rf \
  "${RUNNER_TEMP:?}" \
  "${GITHUB_WORKSPACE:?}"/* \
  "${GITHUB_WORKSPACE:?}"/.[!.]* \
  "${GITHUB_WORKSPACE:?}"/..?*
