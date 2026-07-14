import SwiftUI

extension EnvironmentValues {
    @Entry var menuItemHighlighted: Bool = false
    /// Optional live-refresh monitor injected into menu card views so the provider card
    /// subtitle can reflect the in-flight "Refreshing…" state in place while the NSMenu
    /// stays open, without rebuilding the menu during AppKit tracking.
    @Entry var menuCardRefreshMonitor: MenuCardRefreshMonitor?
}

enum MenuHighlightStyle {
    static let selectionText = Color(nsColor: .selectedMenuItemTextColor)
    static let normalPrimaryText = UsagerBrand.primary
    static let normalSecondaryText = UsagerBrand.secondary

    static func primary(_ highlighted: Bool) -> Color {
        highlighted ? self.selectionText : self.normalPrimaryText
    }

    static func secondary(_ highlighted: Bool) -> Color {
        highlighted ? self.selectionText : self.normalSecondaryText
    }

    static func error(_ highlighted: Bool) -> Color {
        highlighted ? self.selectionText : UsagerBrand.secondary
    }

    static func progressTrack(_ highlighted: Bool) -> Color {
        highlighted ? self.selectionText.opacity(0.22) : UsagerBrand.line.opacity(0.95)
    }

    static func progressTint(_ highlighted: Bool, fallback _: Color) -> Color {
        highlighted ? self.selectionText : UsagerBrand.signal
    }

    static func selectionBackground(_ highlighted: Bool) -> Color {
        highlighted ? UsagerBrand.signal.opacity(0.14) : .clear
    }
}
