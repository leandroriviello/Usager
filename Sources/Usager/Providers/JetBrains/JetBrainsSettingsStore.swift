import Foundation
import UsagerCore

extension SettingsStore {
    func jetbrainsSettingsSnapshot() -> ProviderSettingsSnapshot.JetBrainsProviderSettings {
        ProviderSettingsSnapshot.JetBrainsProviderSettings(
            ideBasePath: self.jetbrainsIDEBasePath.isEmpty ? nil : self.jetbrainsIDEBasePath)
    }
}
