---
name: usager
description: "Usager read. Provider usage, limits, credits, config health. JSON. No writes."
---

# Usager

Read Usager. Never mutate config/auth.

## Run

```bash
skill="${CODEX_HOME:-$HOME/.codex}/skills/usager"
"$skill/scripts/usager" doctor
"$skill/scripts/usager" providers
"$skill/scripts/usager" usage
"$skill/scripts/usager" usage --provider codex
"$skill/scripts/usager" usage --all
```

All stdout: JSON. Upstream Usager shape kept. Less drift, fewer tokens.

## Rules

- Start `doctor` when install/config unknown.
- `usage` reads enabled providers. Prefer this.
- `usage --provider ID` reads one provider.
- `usage --all` expensive; use only when needed.
- Identities hidden by default. `--include-identities` only when user explicitly needs them.
- Secrets always hidden.
- Helper read-only: fixed allowlist only. No config writes, auth repair, enable/disable, key storage.
- Timeout means upstream stuck. Narrow provider or raise `USAGER_TIMEOUT` (default 120 seconds).

## Binary

Auto-find: `USAGER_BIN`, PATH, app bundle, Homebrew cask. If missing: open Usager, Preferences > Advanced > Install CLI; or set `USAGER_BIN`.

Each stdout/stderr stream capped at 1 MiB while fully drained. Timeout kills process group.
