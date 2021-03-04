#!/usr/bin/env bash
set -euxo pipefail
shopt -s inherit_errexit
env

rm -rf \
  "${HOME:?}"/* \
  "${HOME:?}"/.[!.]* \
  "${HOME:?}"/..?* \
  "${GITHUB_WORKSPACE:?}"/* \
  "${GITHUB_WORKSPACE:?}"/.[!.]* \
  "${GITHUB_WORKSPACE:?}"/..?*

all_containers=()
readarray all_containers <<< "$(docker ps --all --quiet)"

protected_containers=()
readarray protected_containers <<< "$(jq -r '.[]' <<< "$INPUT_SERVICE_IDS")"
protected_containers+=( "$(cat /etc/hostname)" )

if test "${#protected_containers[@]}" -eq "${#all_containers[@]}"; then
  exit 0
fi

grep_flags=()
for id in "${protected_containers[@]}"; do
  grep_flags+=('-e')
  grep_flags+=("$(head -c 12 <<< "$id")")
done

printf '%s\n' "${all_containers[@]}" | grep -Fv "${grep_flags[@]}" | xargs docker rm --force
