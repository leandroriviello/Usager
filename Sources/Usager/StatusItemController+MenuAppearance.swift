import AppKit

@MainActor
enum StatusMenuAppearance {
    static func pin(_ menu: NSMenu) {
        self.pin(menu, to: NSAppearance(named: .darkAqua) ?? NSApplication.shared.effectiveAppearance)
        self.applyBlackBaseIfAvailable(to: menu)
        Task { @MainActor in
            self.applyBlackBaseIfAvailable(to: menu)
        }
    }

    static func pin(_ menu: NSMenu, to appearance: NSAppearance) {
        // The exact effective appearance carries accessibility attributes that its name can omit.
        menu.appearance = appearance
    }

    private static func applyBlackBaseIfAvailable(to menu: NSMenu) {
        guard let window = menu.items.lazy.compactMap({ $0.view?.window }).first,
              let contentView = window.contentView
        else { return }

        window.isOpaque = false
        window.backgroundColor = .black
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.88).cgColor

        for subview in contentView.subviews {
            guard let effectView = subview as? NSVisualEffectView else { continue }
            effectView.material = .underWindowBackground
            effectView.blendingMode = .withinWindow
            effectView.state = .active
            effectView.wantsLayer = true
            effectView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.72).cgColor
        }
    }
}
