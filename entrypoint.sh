#!/usr/bin/env bash
set -euxo pipefail
shopt -s inherit_errexit
env
printf '==%s==' "$(jq -r '.[]' <<< "$INPUT_SERVICE_IDS")"

rm -rf \
  "${HOME:?}"/* \
  "${HOME:?}"/.[!.]* \
  "${HOME:?}"/..?* \
  "${GITHUB_WORKSPACE:?}"/* \
  "${GITHUB_WORKSPACE:?}"/.[!.]* \
  "${GITHUB_WORKSPACE:?}"/..?*

all_containers=()
readarray all_containers <<< "$(docker ps --all --quiet)"

self=$(cat /etc/hostname)
protected_containers=("$self")
if test "$INPUT_SERVICE_IDS" != '[]'; then
  readarray protected_containers <<< "$(jq -r '.[]' <<< "$INPUT_SERVICE_IDS")"
fi

if test "${#protected_containers[@]}" -eq "${#all_containers[@]}"; then
  exit 0
fi

grep_flags=()
for id in "${protected_containers[@]}"; do
  grep_flags+=('-e')
  grep_flags+=("$(head -c 12 <<< "$id")")
done

printf '%s\n' "${all_containers[@]}" | grep -Fv "${grep_flags[@]}" | xargs docker rm --force
