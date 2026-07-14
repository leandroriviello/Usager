import Foundation
import UsagerCore

extension UsagerCLI {
    static func cardsHelp(version: String) -> String {
        """
        Usager \(version)

        Usage:
          usager cards [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>] [-v|--verbose]
                        [--provider \(ProviderHelp.list)]
                        [--account <label>] [--account-index <index>] [--all-accounts]
                        [--no-credits] [--no-color] [--status] [--source <auto|web|cli|oauth|api>]
                        [--web-timeout <seconds>] [--web-debug-dump-html] [--antigravity-plan-debug] [--augment-debug]
                        [--brief]

        Description:
          Print a one-shot usage snapshot as a responsive card grid in the terminal.
          Honors enabled providers from config and reuses the same fetch flags as usager usage.
          Failed providers are summarized in a footer instead of error cards.
          Use --brief for a compact table layout (Provider / Usage / Reset).
          Stdout is always the rendered card/table text; --json-output only affects stderr logs.

        Global flags:
          -h, --help      Show help
          -V, --version   Show version
          -v, --verbose   Enable verbose logging
          --no-color      Disable ANSI colors in text output
          --log-level <trace|verbose|debug|info|warning|error|critical>
          --json-output   Emit machine-readable logs (JSONL) to stderr

        Examples:
          usager cards
          usager cards --provider codex
          usager cards --provider all --status
          usager cards --brief
          usager cards --no-color
        """
    }

    static func usageHelp(version: String) -> String {
        """
        Usager \(version)

        Usage:
          usager usage [--format text|json]
                       [--json]
                       [--json-only]
                       [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>] [-v|--verbose]
                       [--provider \(ProviderHelp.list)]
                       [--account <label>] [--account-index <index>] [--all-accounts]
                       [--no-credits] [--no-color] [--pretty] [--status] [--source <auto|web|cli|oauth|api>]
                       [--web-timeout <seconds>] [--web-debug-dump-html] [--antigravity-plan-debug] [--augment-debug]

        Description:
          Print usage from enabled providers as text (default) or JSON. Honors your in-app toggles.
          Output format: use --json (or --format json) for JSON on stdout; use --json-output for JSON logs on stderr.
          Source behavior is provider-specific:
          - Codex: OpenAI web dashboard (usage limits, credits remaining, code review remaining, usage breakdown).
            Auto falls back to Codex CLI only when cookies are missing.
          - Claude: claude.ai API.
            Auto falls back to Claude CLI only when cookies are missing.
          - Kilo: app.kilo.ai API.
            Auto falls back to Kilo CLI when API credentials are missing or unauthorized.
          Token accounts are loaded from the resolved Usager config file.
          Use --account or --account-index to select a specific token account.
          Use --all-accounts to fetch every token account, or every visible Codex account for Codex.
          Account selection requires a single provider.

        Global flags:
          -h, --help      Show help
          -V, --version   Show version
          -v, --verbose   Enable verbose logging
          --no-color      Disable ANSI colors in text output
          --log-level <trace|verbose|debug|info|warning|error|critical>
          --json-output   Emit machine-readable logs (JSONL) to stderr

        Examples:
          usager usage
          usager usage --provider claude
          usager usage --provider gemini
          usager usage --format json --provider all --pretty
          usager usage --provider all --json
          usager usage --status
          usager usage --provider codex --source web --format json --pretty
        """
    }

    static func costHelp(version: String) -> String {
        """
        Usager \(version)

        Usage:
          usager cost [--format text|json]
                       [--json]
                       [--json-only]
                       [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>] [-v|--verbose]
                       [--provider \(ProviderHelp.list)]
                       [--no-color] [--pretty] [--refresh] [--days <days>] [--group-by project]

        Description:
          Print local token cost usage from Claude/Codex native logs plus supported pi sessions.
          This does not require web or CLI access and uses cached scan results unless --refresh is provided.

        Examples:
          usager cost
          usager cost --provider codex --group-by project
          usager cost --provider claude --format json --pretty
        """
    }

    static func sessionsHelp(version: String) -> String {
        """
        Usager \(version)

        Usage:
          usager sessions [--json] [--pretty]
          usager sessions focus <id>

        Description:
          List live local Codex and Claude Code agent sessions.
          JSON uses stable AgentSession field names and ISO-8601 dates.
          Focus activates the owning terminal or desktop app on macOS.

        Examples:
          usager sessions
          usager sessions --json
          usager sessions focus 019f3497-73bf-7df3-a173-4f67d968914a
        """
    }

    static func serveHelp(version: String) -> String {
        """
        Usager \(version)

        Usage:
          usager serve [--port <port>] [--refresh-interval <seconds>]
                         [--request-timeout <seconds>]
                         [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>]
                         [-v|--verbose]

        Description:
          Start a foreground localhost-only HTTP server that exposes existing CLI JSON payloads.
          The server binds to 127.0.0.1 only in this initial version.

        Endpoints:
          GET /health
          GET /usage
          GET /usage?provider=claude
          GET /usage?provider=all
          GET /cost
          GET /cost?provider=codex

        Examples:
          usager serve
          usager serve --port 8080 --refresh-interval 60 --request-timeout 30
          curl http://127.0.0.1:8080/usage?provider=all
        """
    }

    static func configHelp(version: String) -> String {
        """
        Usager \(version)

        Usage:
          usager config validate [--format text|json]
                                 [--json]
                                 [--json-only]
                                 [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>]
                                 [-v|--verbose]
                                 [--pretty]
          usager config dump [--format text|json]
                             [--json]
                             [--json-only]
                             [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>]
                             [-v|--verbose]
                             [--pretty]
          usager config providers [--format text|json] [--json] [--json-only] [--pretty]
          usager config enable --provider <name> [--format text|json] [--json] [--json-only] [--pretty]
          usager config disable --provider <name> [--format text|json] [--json] [--json-only] [--pretty]
          usager config set-api-key --provider <name> (--api-key <key>|--stdin)
                                    [--label <label>] [--usage-scope team]
                                    [--organization-id <org>] [--workspace-id <project>]
                                    [--no-enable]
                                    [--format text|json] [--json] [--json-only] [--pretty]

        Description:
          Validate or print the Usager config file (default: validate).
          providers lists persistent provider enablement.
          enable/disable updates the same provider toggle used by Settings.
          set-api-key stores a provider API key in the resolved config file and enables that provider by default.
          For z.ai team usage, add --usage-scope team with BigModel organization and project IDs; this stores
          the key as a token account instead of a provider-level personal key.

        Examples:
          usager config validate --format json --pretty
          usager config dump --pretty
          usager config providers
          usager config enable --provider grok
          usager config disable --provider cursor
          printf '%s' "$ELEVENLABS_API_KEY" | usager config set-api-key --provider elevenlabs --stdin
          printf '%s' "$Z_AI_API_KEY" | usager config set-api-key --provider zai --stdin \\
            --label Team --usage-scope team --organization-id org_... --workspace-id proj_...
        """
    }

    static func cacheHelp(version: String) -> String {
        """
        Usager \(version)

        Usage:
          usager cache clear <--cookies|--cost|--all>
                              [--provider <name>]
                              [--format text|json]
                              [--json]
                              [--json-only]
                              [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>]
                              [-v|--verbose]
                              [--pretty]

        Description:
          Clear cached data. Use --cookies to clear browser cookie caches (stored in Keychain),
          --cost to clear cost usage scan caches, or --all for both.
          Optionally specify --provider with --cookies to clear cookies for a single provider only.

        Examples:
          usager cache clear --cookies
          usager cache clear --cookies --provider claude
          usager cache clear --cost
          usager cache clear --all
          usager cache clear --all --format json --pretty
        """
    }

    static func diagnoseHelp(version: String) -> String {
        """
        Usager \(version)

        Usage:
          usager diagnose --provider <name|all> --format json
                           [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>]
                           [-v|--verbose]
                           [--redact] [--output <path>]
                           [--pretty]

        Description:
          Run provider diagnostic fetches and print a safe JSON export for issue reporting.
          The export is redacted and omits raw API tokens, cookies, auth headers, emails,
          account IDs, org IDs, raw responses, and billing-history records.

        Examples:
          usager diagnose --provider minimax --format json --redact --output diagnostic.json
          usager diagnose --provider minimax --format json --pretty
          usager diagnose --provider claude --format json --pretty
          usager diagnose --provider all --format json
        """
    }

    static func rootHelp(version: String) -> String {
        """
        Usager \(version)

        Usage:
          usager [--format text|json]
                  [--json]
                  [--json-only]
                  [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>] [-v|--verbose]
                  [--provider \(ProviderHelp.list)]
                  [--account <label>] [--account-index <index>] [--all-accounts]
                  [--no-credits] [--no-color] [--pretty] [--status] [--source <auto|web|cli|oauth|api>]
                  [--web-timeout <seconds>] [--web-debug-dump-html] [--antigravity-plan-debug] [--augment-debug]
          usager cards [--provider \(ProviderHelp.list)] [--brief] [--no-color] [--status]
          usager cost [--format text|json]
                       [--json]
                       [--json-only]
                       [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>] [-v|--verbose]
                       [--provider \(ProviderHelp.list)] [--no-color] [--pretty] [--refresh]
                       [--days <days>] [--group-by project]
          usager sessions [--json] [--pretty]
          usager sessions focus <id>
          usager serve [--port <port>] [--refresh-interval <seconds>]
                       [--request-timeout <seconds>]
                       [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>] [-v|--verbose]
          usager config <validate|dump|providers> [--format text|json]
                                        [--json]
                                        [--json-only]
                                        [--json-output] [--log-level <trace|verbose|debug|info|warning|error|critical>]
                                        [-v|--verbose]
                                        [--pretty]
          usager config enable --provider <name>
          usager config disable --provider <name>
          usager config set-api-key --provider <name> (--api-key <key>|--stdin)
          usager config set-api-key --provider zai --stdin --usage-scope team
                                   --organization-id <org> --workspace-id <project>
          usager cache clear <--cookies|--cost|--all> [--provider <name>]
          usager diagnose --provider <name|all> --format json [--redact] [--output <path>] [--pretty]

        Global flags:
          -h, --help      Show help
          -V, --version   Show version
          -v, --verbose   Enable verbose logging
          --no-color      Disable ANSI colors in text output
          --log-level <trace|verbose|debug|info|warning|error|critical>
          --json-output   Emit machine-readable logs (JSONL) to stderr

        Examples:
          usager
          usager --format json --provider all --pretty
          usager --provider all --json
          usager --provider gemini
          usager cards --provider all --status
          usager cards --brief
          usager cost --provider claude --format json --pretty
          usager sessions --json
          usager serve --port 8080
          usager config validate --format json --pretty
          usager config enable --provider grok
          usager config set-api-key --provider elevenlabs --stdin
          usager cache clear --cookies
          usager diagnose --provider minimax --format json --redact --output diagnostic.json
          usager diagnose --provider minimax --format json --pretty
          usager diagnose --provider all --format json
        """
    }
}
