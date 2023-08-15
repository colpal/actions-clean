#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace -o pipefail
shopt -s inherit_errexit nullglob dotglob

rm -rf "${HOME:?}"/* "${GITHUB_WORKSPACE:?}"/*

if test "${RUNNER_DEBUG:-0}" != '1'; then
  set +o xtrace
fi

all_containers=()
readarray all_containers <<< "$(docker ps --all --quiet)"

protected_containers=()
if test "$INPUT_SERVICE_IDS" != '[]'; then
  service_ids=$(jq -r '.[]' <<< "$INPUT_SERVICE_IDS")
  readarray protected_containers <<< "$service_ids"
fi
self=$(cat /etc/hostname)
protected_containers+=("$self")
protected_containers+=("kind-control-plane")

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
