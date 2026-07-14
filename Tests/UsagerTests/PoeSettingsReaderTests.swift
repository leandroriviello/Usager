import Foundation
import Testing
import UsagerCore

struct PoeSettingsReaderTests {
    @Test
    func `api key trims quotes`() {
        let env = [PoeSettingsReader.apiKeyEnvironmentKey: " 'poe-key' "]
        #expect(PoeSettingsReader.apiKey(environment: env) == "poe-key")
    }
}
