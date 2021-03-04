#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit nullglob dotglob

set -x
rm -rf \
  "${HOME:?}"/* \
  "${GITHUB_WORKSPACE:?}"/* \
set +x

all_containers=()
readarray all_containers <<< "$(docker ps --all --quiet)"

self=$(cat /etc/hostname)
protected_containers=("$self")
if test "$INPUT_SERVICE_IDS" != '[]'; then
  readarray protected_containers <<< "$(jq -r '.[]' <<< "$INPUT_SERVICE_IDS")"
fi

if test "${#protected_containers[@]}" -eq "${#all_containers[@]}"; then
  echo 'No "extra" containers detected.' >&2
  exit 0
fi

grep_flags=()
for id in "${protected_containers[@]}"; do
  grep_flags+=('-e')
  grep_flags+=("$(head -c 12 <<< "$id")")
done

printf '%s\n' "${all_containers[@]}" | grep -Fv "${grep_flags[@]}" | xargs docker rm --force
