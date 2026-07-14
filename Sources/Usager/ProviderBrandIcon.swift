import AppKit
import UsagerCore

@MainActor
enum ProviderBrandIcon {
    private static let size = NSSize(width: 16, height: 16)
    private static var cache: [UsageProvider: NSImage] = [:]

    /// Lazy-loaded resource bundle for provider icons.
    private static let resourceBundle: Bundle? = {
        guard Bundle.main.bundleURL.pathExtension == "app" else {
            return Bundle.module
        }
        // SwiftPM creates a Usager_Usager.bundle for resources in the Usager target.
        if let bundleURL = Bundle.main.url(forResource: "Usager_Usager", withExtension: "bundle"),
           let bundle = Bundle(url: bundleURL)
        {
            return bundle
        }
        // Fallback to main bundle for development/testing.
        return Bundle.main
    }()

    static func image(for provider: UsageProvider) -> NSImage? {
        if let cached = self.cache[provider] {
            return cached
        }

        let baseName = ProviderDescriptorRegistry.descriptor(for: provider).branding.iconResourceName
        guard let bundle = self.resourceBundle else {
            return nil
        }
        guard let url = bundle.url(forResource: baseName, withExtension: "svg"),
              let image = NSImage(contentsOf: url)
        else {
            return nil
        }

        image.size = self.size
        image.isTemplate = true
        self.cache[provider] = image
        return image
    }

    static func resetCacheForTesting() {
        self.cache.removeAll()
    }
}
