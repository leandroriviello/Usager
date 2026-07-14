import Testing
@testable import Usager

struct KeychainMigrationTests {
    @Test
    func `migration list covers known keychain items`() {
        let items = Set(KeychainMigration.itemsToMigrate.map(\.label))
        let expected: Set = [
            "com.leandroriviello.Usager:codex-cookie",
            "com.leandroriviello.Usager:claude-cookie",
            "com.leandroriviello.Usager:cursor-cookie",
            "com.leandroriviello.Usager:factory-cookie",
            "com.leandroriviello.Usager:minimax-cookie",
            "com.leandroriviello.Usager:minimax-api-token",
            "com.leandroriviello.Usager:augment-cookie",
            "com.leandroriviello.Usager:copilot-api-token",
            "com.leandroriviello.Usager:zai-api-token",
            "com.leandroriviello.Usager:synthetic-api-key",
        ]

        let missing = expected.subtracting(items)
        #expect(missing.isEmpty, "Missing migration entries: \(missing.sorted())")
    }
}
