#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GROUP_SIZE="${USAGER_TEST_GROUP_SIZE:-12}"
SUITE_TIMEOUT="${USAGER_TEST_SUITE_TIMEOUT:-180}"

cd "${ROOT_DIR}"

# Defense in depth: test processes also self-detect, but keep this explicit so runner changes cannot
# expose the user's login Keychain. Deliberate isolated Keychain tests must opt in by setting the allow flag.
if [[ "${USAGER_ALLOW_TEST_KEYCHAIN_ACCESS:-}" != "1" ]]; then
  export USAGER_SUPPRESS_TEST_KEYCHAIN_ACCESS=1
fi

ARGS=(
  --group-size "${GROUP_SIZE}"
  --timeout "${SUITE_TIMEOUT}"
)

if [[ -n "${USAGER_TEST_SHARD_INDEX:-}" || -n "${USAGER_TEST_SHARD_COUNT:-}" ]]; then
  ARGS+=(
    --shard-index "${USAGER_TEST_SHARD_INDEX:?USAGER_TEST_SHARD_COUNT requires USAGER_TEST_SHARD_INDEX}"
    --shard-count "${USAGER_TEST_SHARD_COUNT:?USAGER_TEST_SHARD_INDEX requires USAGER_TEST_SHARD_COUNT}"
  )
fi

exec python3 "${ROOT_DIR}/Scripts/ci_swift_test_by_suite.py" "${ARGS[@]}" "$@"
