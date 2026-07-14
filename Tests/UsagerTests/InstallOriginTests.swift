import Foundation
import Testing
@testable import Usager

struct InstallOriginTests {
    @Test
    func `detects homebrew caskroom`() {
        #expect(
            InstallOrigin
                .isHomebrewCask(
                    appBundleURL: URL(fileURLWithPath: "/opt/homebrew/Caskroom/usager/1.0.0/Usager.app")))
        #expect(
            InstallOrigin
                .isHomebrewCask(appBundleURL: URL(fileURLWithPath: "/usr/local/Caskroom/usager/1.0.0/Usager.app")))
        #expect(!InstallOrigin.isHomebrewCask(appBundleURL: URL(fileURLWithPath: "/Applications/Usager.app")))
    }
}
