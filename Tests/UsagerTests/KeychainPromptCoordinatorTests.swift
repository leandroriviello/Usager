import Testing
import UsagerCore
@testable import Usager

struct KeychainPromptCoordinatorTests {
    @Test
    func `detects raw SwiftPM debug executable`() {
        #expect(KeychainPromptCoordinator.isUnbundledUsagerExecutable(
            "/Users/me/Usager/.build/arm64-apple-macosx/debug/Usager"))
        #expect(KeychainPromptCoordinator.isUnbundledUsagerExecutable(
            "/Users/me/Usager/.build/debug/Usager"))
    }

    @Test
    func `detects raw SwiftPM release executable`() {
        #expect(KeychainPromptCoordinator.isUnbundledUsagerExecutable(
            "/Users/me/Usager/.build/arm64-apple-macosx/release/Usager"))
    }

    @Test
    func `detects custom SwiftPM scratch path`() {
        #expect(KeychainPromptCoordinator.isUnbundledUsagerExecutable(
            "/tmp/usager-build/arm64-apple-macosx/debug/Usager"))
    }

    @Test
    func `keeps packaged app keychain behavior`() {
        #expect(!KeychainPromptCoordinator.isUnbundledUsagerExecutable(
            "/Applications/Usager.app/Contents/MacOS/Usager"))
        #expect(!KeychainPromptCoordinator.isUnbundledUsagerExecutable(
            "/Users/me/Usager/.build/package/Usager.app/Contents/MacOS/Usager"))
    }

    @Test
    func `ignores unrelated executable paths`() {
        #expect(!KeychainPromptCoordinator.isUnbundledUsagerExecutable(
            "/Users/me/Usager/.build/debug/UsagerCLI"))
        #expect(!KeychainPromptCoordinator.isUnbundledUsagerExecutable(""))
        #expect(!KeychainPromptCoordinator.isUnbundledUsagerExecutable("Usager"))
    }

    @Test
    func `browser cookie alert explains password handling and opt out`() {
        let model = KeychainPromptCoordinator.browserCookieAlertModel(label: "Chrome Safe Storage")

        #expect(model.title == "Keychain Access Required")
        #expect(model.message.contains("Chrome Safe Storage"))
        #expect(model.message.contains("macOS—not Usager—handles any Mac login password entry"))
        #expect(model.message.contains("Settings → Advanced"))
        #expect(model.primaryButtonTitle == "OK")
        #expect(model.learnMoreButtonTitle == "Learn More…")
        #expect(model.documentationURL.hasSuffix("/docs/keychain-prompts.md"))
    }

    @Test
    func `provider alert preserves the requested keychain purpose`() {
        let context = KeychainPromptContext(
            kind: .claudeOAuth,
            service: "Claude Code-credentials",
            account: nil)

        let model = KeychainPromptCoordinator.alertModel(for: context)

        #expect(model.message.contains("Claude Code OAuth token"))
        #expect(model.message.contains("fetch your Claude usage"))
        #expect(model.learnMoreButtonTitle == "Learn More…")
    }
}
